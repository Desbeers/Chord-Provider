//
//  SourceViewController.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CAdw
import ChordProviderCore
import CSourceView

public final class SourceViewController {

    /// The GTKSourceView
    let sourceView: ViewStorage
    /// The GTKTextBuffer
    let textBuffer: ViewStorage
    /// The current line in the editor
    var currentLine = Song.Section.Line()
    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false
    /// Bool if the editor has a selection
    public var hasSelection: Bool = false

    // MARK: Snippets

    /// The snippets provider
    let snippets = gtk_source_completion_snippets_new()
    /// Bool if we should show snippets
    /// - Note Show them when a line starts with a `{` and the line does not contain the closing bracvket `}`
    var snippetsAvailable: Bool = false
    /// Bool if the snippets are loaded in the completion provider
    var snippetsLoaded: Bool = false
    /// Idle handling of adding snippets
    var snippetsIdle: Any?
    /// The completion object
    let completion: OpaquePointer?

    // MARK: Debouncers

    let lineNumberDebounce = Debouncer(delay: 0.1)
    let snapshotDebounce = Debouncer(delay: 0.5)

    /// Init the controller
    /// - Parameters:
    ///   - bridge: The source view bridge
    ///   - language: The editor language
    public init(bridge: Binding<SourceViewBridge>, language: Language) {
        textBuffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        sourceView = ViewStorage(
            gtk_source_view_new_with_buffer(textBuffer.opaquePointer?.cast())?.opaque(),
            content: ["textBuffer": [textBuffer]]
        )
        /// Store the binding of the bridge
        sourceView.fields["bridgeBinding"] = bridge

        // MARK: Snippets

        completion = gtk_source_view_get_completion(sourceView.opaquePointer?.cast())

        // MARK: Style

        /// Set the language for text highlight
        SourceViewController.setupLanguage(textBuffer: textBuffer, language: language)
        /// Set the style
        let styleManager = adw_style_manager_get_default()
        SourceViewController.setStyle(sourceView: sourceView, textBuffer: textBuffer, manager: styleManager)
        /// Add a *notification* for style changes
        textBuffer.notify(name: "dark", pointer: styleManager) {
            SourceViewController.setStyle(sourceView: self.sourceView, textBuffer: self.textBuffer, manager: styleManager)
        }

        gtk_source_init()
        /// Connect signal callbacks
        sourceview_connect_signals(
            sourceView.opaquePointer?.cast(),
            sourceview_insert_cb,
            sourceview_delete_cb,
            sourceview_click_cb,
            sourceview_key_cb,
            Unmanaged.passUnretained(self).toOpaque()
        )

        textBuffer.notify(name: "cursor-position") {
            self.lineNumberDebounce.schedule {
                self.updateCurrentLine()
                self.scheduleSnippetCheck()
            }
        }
    }

    /// Set the style of the editor
    /// - Parameters:
    ///   - textBuffer: The text buffer
    ///   - styleManager: The `Adwaita` style manager
    static func setStyle(sourceView: ViewStorage, textBuffer: ViewStorage, manager styleManager: OpaquePointer?) {
        let isDark = adw_style_manager_get_dark(styleManager)
        let theme = isDark == 1 ? "Adwaita-dark" : "Adwaita"
        let manager = gtk_source_style_scheme_manager_get_default()
        let scheme = gtk_source_style_scheme_manager_get_scheme(manager, theme)
        gtk_source_buffer_set_style_scheme(textBuffer.opaquePointer?.cast(), scheme)
        setMarksStyle(sourceView: sourceView, darkMode: isDark == 1)
    }

    // MARK: Cursor movement

    static func moveCursorToFirstLine(sourceView: ViewStorage, textBuffer: ViewStorage) {
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(textBuffer.opaquePointer?.cast(), &iter)
        /// Place cursor at start of line 0
        gtk_text_buffer_place_cursor(textBuffer.opaquePointer?.cast(), &iter)
        /// Scroll to cursor
        if let insertMark = gtk_text_buffer_get_insert(textBuffer.opaquePointer?.cast()) {
            gtk_text_view_scroll_mark_onscreen(
                sourceView.opaquePointer?.cast(),
                insertMark
            )
        }
    }

    // MARK: ChordPro language and snippets

    static func setupLanguage(textBuffer: ViewStorage, language: Language) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            gtk_source_language_manager_append_search_path(manager, path)
            addSnippetsPath(path)
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(textBuffer.opaquePointer?.cast(), lang)
    }

    // MARK: Current line information

    func updateCurrentLine() {
        guard
            let bridgeBinding = sourceView.fields["bridgeBinding"] as? Binding<SourceViewBridge>,
            let textBufferPtr: UnsafeMutablePointer<GtkTextBuffer> = textBuffer.opaquePointer?.cast()
        else {
            return
        }
        var bridge = bridgeBinding.wrappedValue
        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            textBufferPtr,
            &iter,
            gtk_text_buffer_get_insert(textBufferPtr)
        )
        let currentLineNumber = Int(gtk_text_iter_get_line(&iter) + 1)

        let totalLines = bridge.song.totalLines

        self.currentLine = bridge.songLines[safe: currentLineNumber - 1] ?? Song.Section.Line(sourceLineNumber: totalLines)

        isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        hasSelection = gtk_text_buffer_get_has_selection(textBufferPtr) != 0
        
        bridge.currentLine = currentLine
        bridge.isAtBeginningOfLine = isAtBeginningOfLine
        bridge.hasSelection = hasSelection
        bridgeBinding.wrappedValue = bridge
    }
}

// MARK: - Snapshots
//
// Sync the text buffer to the Swift text binding

extension SourceViewController {

    func snapshotText() -> String {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(textBuffer.opaquePointer?.cast(), &start)
        gtk_text_buffer_get_end_iter(textBuffer.opaquePointer?.cast(), &end)
        guard let cStr = gtk_text_buffer_get_text(textBuffer.opaquePointer?.cast(), &start, &end, true.cBool) else {
            return ""
        }
        return String(cString: cStr)
    }

    func scheduleSnapshot() {
        snapshotDebounce.schedule {
            if self.snippetsAvailable {
                /// Don't flush the text or else the completion popup will flicker
                return
            }
            guard
                let textBuffer = self.sourceView.content["textBuffer"]?.first,
                let bridgeBinding = self.sourceView.fields["bridgeBinding"] as? Binding<SourceViewBridge>
            else {
                return
            }
            /// Clear the log for a new parsing
            LogUtils.shared.clearLog()
            let text = self.snapshotText()
            /// Get the values of the bridge binding
            var bridge = bridgeBinding.wrappedValue
            bridge.song.content = text
            bridge.song = ChordProParser.parse(song: bridge.song, settings: bridge.coreSettings)
            /// Clear all markers and add new ones if needed
            self.clearMarks(textBuffer: textBuffer)
            if bridge.coreSettings.showWarnings {
                /// Get all lines, removing anything added by the parser
                let lines = bridge.song.allLines.filter {$0.sourceLineNumber > 0}
                bridge.songLines = lines
                for line in lines.filter({ $0.warnings != nil }) {
                    let level = line.warnings?.compactMap(\.level).sorted().last ?? .info
                    self.addMark(
                        textBuffer: textBuffer,
                        lineNumber: line.sourceLineNumber,
                        category: level.rawValue
                    )
                }
            }
            /// Update the bridge
            bridgeBinding.wrappedValue = bridge
            /// Update the current line
            self.updateCurrentLine()
        }
    }
}

// MARK: - Swift callbacks for `C` functions

extension SourceViewController {

    static func controller(from userData: UnsafeMutableRawPointer?) -> SourceViewController? {
        guard let userData else { return nil }
        return Unmanaged<SourceViewController>
            .fromOpaque(userData)
            .takeUnretainedValue()
    }
}

/// Handle insert event
@_cdecl("sourceview_insert_cb")
public func sourceview_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = SourceViewController.controller(from: userData) else { return }
    controller.scheduleSnapshot()
}

/// Handle delete event
@_cdecl("sourceview_delete_cb")
public func sourceview_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = SourceViewController.controller(from: userData) else { return }
    controller.scheduleSnapshot()
}

/// Handle click event
@_cdecl("sourceview_click_cb")
public func sourceview_click_cb(
    click: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData, click == 3 else { return }
    guard let controller = SourceViewController.controller(from: userData) else { return }
    guard let binding = controller.sourceView.fields["bridgeBinding"] as? Binding<SourceViewBridge> else { return }
    if let directive = controller.currentLine.directive, directive.editable {
        binding.handleDirective.wrappedValue = directive
        binding.showEditDirectiveDialog.wrappedValue = true
    }
}

/// Handle key event
@_cdecl("sourceview_key_cb")
public func sourceview_key_cb(
    keyval: UInt32,
    keycode: UInt32,
    state: GdkModifierType,
    userData: UnsafeMutableRawPointer?
) -> gboolean {

    guard let controller = SourceViewController.controller(from: userData) else {
        return 0
    }
    guard state.rawValue == 0,
          keyval == UInt32(GDK_KEY_bracketleft) else {
        return 0
    }
    guard let bufferPointer: UnsafeMutablePointer<GtkTextBuffer> =
          controller.textBuffer.opaquePointer?.cast() else {
        return 0
    }
    gtk_text_buffer_insert_at_cursor(bufferPointer, "[", -1)
    gtk_text_buffer_insert_at_cursor(bufferPointer, "]", -1)
    var iter = GtkTextIter()
    guard let mark = gtk_text_buffer_get_insert(bufferPointer) else {
        return 1
    }
    gtk_text_buffer_get_iter_at_mark(bufferPointer, &iter, mark)
    gtk_text_iter_backward_char(&iter)
    gtk_text_buffer_place_cursor(bufferPointer, &iter)
    // Return 1 because the bracket is aready handled now
    return 1
}

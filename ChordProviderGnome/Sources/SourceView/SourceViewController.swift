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
    let storage: ViewStorage
    /// The GTKTextBuffer
    let buffer: ViewStorage
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

    let lineNumberDebounce = Debouncer(delay: 0.1, queue: .main)
    let snapshotDebounce = Debouncer(delay: 0.5, queue: .main)

    /// Init the controller
    /// - Parameters:
    ///   - text: The editor text
    ///   - language: The editor language
    public init(bridge: Binding<SourceViewBridge>, language: Language) {
        buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        SourceViewController.setupLanguage(buffer: buffer, language: language)
        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), bridge.song.content.wrappedValue, -1)
        storage = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.opaquePointer?.cast())?.opaque(),
            content: ["buffer": [buffer]]
        )
        SourceViewController.moveCursorToFirstLine(storage: storage, buffer: buffer)
        /// Store the binding of the bridge
        storage.fields["bridgeBinding"] = bridge

        // MARK: Snippets

        completion = gtk_source_view_get_completion(storage.opaquePointer?.cast())

        // MARK: Style

        /// Set the style
        let styleManager = adw_style_manager_get_default()
        SourceViewController.setStyle(buffer: buffer, manager: styleManager)
        /// Add a *notification* for style changes
        buffer.notify(name: "dark", pointer: styleManager) {
            SourceViewController.setStyle(buffer: self.buffer, manager: styleManager)
        }

        gtk_source_init()
        /// Connect signal callbacks
        sourceview_connect_signals(
            storage.opaquePointer?.cast(),
            sourceview_insert_cb,
            sourceview_delete_cb,
            sourceview_click_cb,
            Unmanaged.passUnretained(self).toOpaque()
        )

        buffer.notify(name: "cursor-position") { [self] in
            lineNumberDebounce.schedule {
                self.updateCurrentLine()
                self.scheduleSnippetCheck()
            }
        }

        // MARK: Marks

        sourceview_install_marks(storage.opaquePointer?.cast(), "bookmark")

        /// Render the song
        scheduleSnapshot()
    }
    deinit {
        print("DEINT CONTROLLER")
    }
    
    /// Set the style of the editor
    /// - Parameters:
    ///   - buffer: The text buffer
    ///   - styleManager: The `Adwaita` style manager
    static func setStyle(buffer: ViewStorage, manager styleManager: OpaquePointer?) {
        let isDark = adw_style_manager_get_dark(styleManager)
        let theme = isDark == 1 ? "Adwaita-dark" : "Adwaita"
        let manager = gtk_source_style_scheme_manager_get_default()
        let scheme = gtk_source_style_scheme_manager_get_scheme(manager, theme)
        gtk_source_buffer_set_style_scheme(buffer.opaquePointer?.cast(), scheme);
    }

    // MARK: Cursor movement

    static func moveCursorToFirstLine(storage: ViewStorage, buffer: ViewStorage) {
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), &iter)
        /// Place cursor at start of line 0
        gtk_text_buffer_place_cursor(buffer.opaquePointer?.cast(), &iter)
        /// Scroll to cursor
        if let insertMark = gtk_text_buffer_get_insert(buffer.opaquePointer?.cast()) {
            gtk_text_view_scroll_mark_onscreen(
                storage.opaquePointer?.cast(),
                insertMark
            )
        }
    }

    // MARK: ChordPro language and snippets

    static func setupLanguage(buffer: ViewStorage, language: Language) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            gtk_source_language_manager_append_search_path(manager, path)
            path.withCString { cString in
                sourceview_add_snippets_path(cString)
            }
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.opaquePointer?.cast(), lang)
    }

    func updateCurrentLine() {
        guard
            let bridgeBinding = storage.fields["bridgeBinding"] as? Binding<SourceViewBridge>,
            let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> = buffer.opaquePointer?.cast()
        else {
            return
        }

        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            bufferPtr,
            &iter,
            gtk_text_buffer_get_insert(bufferPtr)
        )
        let currentLineNumber = Int(gtk_text_iter_get_line(&iter) + 1)


        let number = bridgeBinding.song.lines.wrappedValue

        self.currentLine = bridgeBinding.songLines[safe: currentLineNumber - 1].wrappedValue ?? Song.Section.Line(sourceLineNumber: number)

        isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        hasSelection = gtk_text_buffer_get_has_selection(bufferPtr) != 0
        var bridge = bridgeBinding.wrappedValue
        /// Only update the binding when needed
        if bridge.currentLine.sourceLineNumber != currentLineNumber || bridge.isAtBeginningOfLine != isAtBeginningOfLine || bridge.hasSelection != hasSelection {
            bridge.currentLine = currentLine
            bridge.isAtBeginningOfLine = isAtBeginningOfLine
            bridge.hasSelection = hasSelection
            bridgeBinding.wrappedValue = bridge
        }
    }
}

// MARK: - Snippets

extension SourceViewController {

    func handleSnippets() {
        let view: UnsafeMutablePointer<GtkSourceView>? = storage.opaquePointer?.cast()
        snippetsAvailable = sourceview_check_for_brackets(view) == 1
        if snippetsAvailable {
            if !snippetsLoaded {
                /// Load the snippets
                gtk_source_completion_add_provider(completion, snippets?.opaque())
                snippetsLoaded = true
            }
        } else if snippetsLoaded {
            /// Remove the snippets
            gtk_source_completion_remove_provider(completion, snippets?.opaque())
            snippetsLoaded = false
        }
    }

    func scheduleSnippetCheck() {
        if snippetsIdle != nil { return }
        snippetsIdle = Idle { [self] in
            snippetsIdle = nil
            handleSnippets()
        }
    }

}

// MARK: - Snapshots
//
// Sync the text buffer to the Swift text binding

extension SourceViewController {

    func snapshotText() -> String {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), &start)
        gtk_text_buffer_get_end_iter(buffer.opaquePointer?.cast(), &end)
        guard let cStr = gtk_text_buffer_get_text(buffer.opaquePointer?.cast(), &start, &end, true.cBool) else {
            return ""
        }
        return String(cString: cStr)
    }

    func scheduleSnapshot() {
        snapshotDebounce.schedule { [self] in
            if snippetsAvailable {
                /// Don't flush the text or else the completion popup will flicker
                return
            }
            guard
                let buffer = storage.content["buffer"]?.first,
                let binding = storage.fields["bridgeBinding"] as? Binding<SourceViewBridge>
            else {
                return
            }
            /// Clear the log for a new parsing
            LogUtils.shared.clearLog()
            let text = snapshotText()
            binding.song.content.wrappedValue = text
            binding.song.wrappedValue = ChordProParser.parse(song: binding.song.wrappedValue, settings: binding.song.wrappedValue.settings)
            /// Clear all markers and add new ones if needed
            sourceview_clear_marks(buffer.opaquePointer?.cast(), "bookmark")
            let lines = binding.wrappedValue.song.sections.flatMap(\.lines).filter {$0.sourceLineNumber > 0}
            binding.songLines.wrappedValue = lines
            /// Update the current line
            updateCurrentLine()
            for line in lines.filter( { $0.warnings != nil } ) {
                sourceview_add_mark(buffer.opaquePointer?.cast(), gint(line.sourceLineNumber), "bookmark")
            }
        }
    }
}

// MARK: - Swift callbacks for `C` functions

@_cdecl("sourceview_insert_cb")
public func sourceview_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData, let text = text else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    /// Convert C string to Swift String
    let insertedText = String(cString: text)

    /// Check if the inserted text is exactly "["
    if insertedText == "[" {
        Idle {
            guard let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> =
                    controller.buffer.opaquePointer?.cast()
            else { return }

            /// Get insert mark
            guard let insertMark = gtk_text_buffer_get_insert(bufferPtr) else { return }

            /// Insert closing bracket
            var iter = GtkTextIter()
            gtk_text_buffer_get_iter_at_mark(bufferPtr, &iter, insertMark)
            gtk_text_buffer_insert(bufferPtr, &iter, "]", -1)

            /// Move cursor back between brackets
            gtk_text_iter_backward_char(&iter)
            gtk_text_buffer_place_cursor(bufferPtr, &iter)
        }
    }

    /// Schedule undo snapshot / any other callbacks
    controller.scheduleSnapshot()
}


@_cdecl("sourceview_delete_cb")
public func sourceview_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    controller.scheduleSnapshot()
}

@_cdecl("sourceview_click_cb")
public func sourceview_click_cb(
    click: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData, click == 3 else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    guard let binding = controller.storage.fields["bridgeBinding"] as? Binding<SourceViewBridge> else { return }
    if let directive = controller.currentLine.directive, directive.editable {
        binding.handleDirective.wrappedValue = directive
        binding.showEditDirectiveDialog.wrappedValue = true
    }
}

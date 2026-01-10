//
//  SourceViewController.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CSourceView

public final class SourceViewController {

    /// The GTKSourceView
    let storage: ViewStorage
    /// The GTKTextBuffer
    let buffer: ViewStorage
    /// The current line in the editor
    var currentLine: Int = 1

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

    // MARK: Snapshots

    /// The debounced snapshot schedule
    var snapshotSchedule: guint = 0

    /// Init the controller
    /// - Parameters:
    ///   - text: The editor text
    ///   - language: The editor language
    init(bridge: Binding<SourceViewBridge>, language: Language) {
        buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        sourceview_set_theme(buffer.opaquePointer?.cast())
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

        gtk_source_init()
        /// Connect signal callbacks
        sourceview_connect_signals(
            buffer.opaquePointer?.cast(),
            sourceview_insert_cb,
            sourceview_delete_cb,
            sourceview_cursor_cb,
            Unmanaged.passUnretained(self).toOpaque()
        )
        sourceview_install_marks(storage.opaquePointer?.cast(), "bookmark")

        /// Render the song
        scheduleSnapshot(self)
    }
    deinit {
        print("DEINT CONTROLLER")
    }

    // MARK: Cursor movement

    static func moveCursorToFirstLine(storage: ViewStorage, buffer: ViewStorage) {
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), &iter)
        /// Place cursor at start of line 0
        gtk_text_buffer_place_cursor(buffer.opaquePointer?.cast(), &iter)
        // Scroll to cursor
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
            let bridgeBinding = storage.fields["bridgeBinding"] as? Binding<SourceViewBridge>
        else {
            return
        }
        guard let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> =
            buffer.opaquePointer?.cast()
        else { return }

        var iter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            bufferPtr,
            &iter,
            gtk_text_buffer_get_insert(bufferPtr)
        )
        currentLine = Int(gtk_text_iter_get_line(&iter) + 1)

        var bridge = bridgeBinding.wrappedValue
        /// Only update the binding when needed
        if bridge.currentLine != self.currentLine {
            bridge.currentLine = currentLine
            bridgeBinding.wrappedValue = bridge
        }
    }
}

// MARK: - Snippets

func handleSnippets(controller: SourceViewController) {
    let view: UnsafeMutablePointer<GtkSourceView>? = controller.storage.opaquePointer?.cast()
    controller.snippetsAvailable = sourceview_check_for_brackets(view) == 1
    if controller.snippetsAvailable {
        if !controller.snippetsLoaded {
            /// Load the snippets
            gtk_source_completion_add_provider(controller.completion, controller.snippets?.opaque())
            controller.snippetsLoaded = true
        }
    } else if controller.snippetsLoaded {
        /// Remove the snippets
        gtk_source_completion_remove_provider(controller.completion, controller.snippets?.opaque())
        controller.snippetsLoaded = false
    }
}

func scheduleSnippetCheck(_ controller: SourceViewController) {
    if controller.snippetsIdle != nil { return }
    controller.snippetsIdle = Idle {
        controller.snippetsIdle = nil
        handleSnippets(controller: controller)
    }
}

// MARK: - Snapshots
//
// Sync the text buffer to the Swift text binding

func snapshotText(buffer: ViewStorage) -> String {
    var start = GtkTextIter()
    var end = GtkTextIter()
    gtk_text_buffer_get_start_iter(buffer.opaquePointer?.cast(), &start)
    gtk_text_buffer_get_end_iter(buffer.opaquePointer?.cast(), &end)
    guard let cStr = gtk_text_buffer_get_text(buffer.opaquePointer?.cast(), &start, &end, true.cBool) else {
        return ""
    }
    return String(cString: cStr)
}

func scheduleSnapshot(_ controller: SourceViewController) {
    /// Check if there is already a snapshot scheduled
    if controller.snapshotSchedule != 0, let gsource = g_main_context_find_source_by_id(nil, controller.snapshotSchedule) {
        g_source_destroy(gsource)
        controller.snapshotSchedule = 0
    }
    let source: guint = sourceview_add_schedule(
        500,
        flush_snapshot_cb,
        Unmanaged.passUnretained(controller).toOpaque()
    )
    /// Schedule new snapshot
    controller.snapshotSchedule = source
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
    scheduleSnapshot(controller)
}


@_cdecl("sourceview_delete_cb")
public func sourceview_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnapshot(controller)
}

@_cdecl("sourceview_cursor_cb")
public func sourceview_cursor_cb(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    controller.updateCurrentLine()
    scheduleSnippetCheck(controller)
}

@_cdecl("flush_snapshot_cb")
public func flush_snapshot_cb(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else {
        return
    }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    if controller.snippetsAvailable {
        /// Don't flush the text or else the completion popup will flicker
        return
    }
    controller.snapshotSchedule = 0
    guard
        let buffer = controller.storage.content["buffer"]?.first,
        let binding = controller.storage.fields["bridgeBinding"] as? Binding<SourceViewBridge>
    else {
        return
    }
    /// Clear the log for a new parsing
    LogUtils.shared.clearLog()
    let text = snapshotText(buffer: buffer)
    binding.song.content.wrappedValue = text
    binding.song.wrappedValue = ChordProParser.parse(song: binding.song.wrappedValue, settings: binding.song.wrappedValue.settings)
    /// Clear all markers and add new ones if needed
    sourceview_clear_marks(buffer.opaquePointer?.cast(), "bookmark")
    let lines = binding.wrappedValue.song.sections.flatMap(\.lines).filter {$0.warnings != nil}
    for line in lines {
        sourceview_add_mark(controller.buffer.opaquePointer?.cast(), gint(line.sourceLineNumber), "bookmark")
    }
}

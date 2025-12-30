//
//  SourceViewController.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CCodeEditor

final class SourceViewController {

    /// The GTKSourceView
    let storage: ViewStorage
    /// The GTKTextBuffer
    let buffer: ViewStorage

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

    /// The hash of the last snapshot
    var lastSnapshotHash: Int
    /// The debounced snapshot schedule
    var snapshotSchedule: guint = 0

    /// Init the controller
    /// - Parameters:
    ///   - text: The editor text
    ///   - language: The editor language
    init(text: Binding<String>, language: Language) {

        self.lastSnapshotHash = text.wrappedValue.hashValue
        buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        codeeditor_buffer_set_theme_adaptive(buffer.opaquePointer?.cast())
        SourceViewController.setupLanguage(buffer: buffer, language: language)
        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), text.wrappedValue, -1)

        storage = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.opaquePointer?.cast())?.opaque(),
            content: ["buffer": [buffer]]
        )
        /// Store the binding of the text
        storage.fields["textBinding"] = text

        // MARK: Snippets

        completion = gtk_source_view_get_completion(storage.opaquePointer?.cast())

        gtk_source_init()

        /// Connect signal callbacks
        codeeditor_connect_buffer_signals(
            buffer.opaquePointer?.cast(),
            codeeditor_insert_cb,
            codeeditor_delete_cb,
            cursor_position_cb,
            Unmanaged.passUnretained(self).toOpaque()
        )
    }
    deinit {
        print("DEINT CONTROLLER")
    }

    func syncFromSwiftIfNeeded() {
        guard
            let binding = storage.fields["textBinding"] as? Binding<String>
        else {
            return
        }
        let newValue = binding.wrappedValue
        let newHash = newValue.hashValue
        guard newHash != self.lastSnapshotHash else {
            return
        }
        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), newValue, -1)
        /// Make a new hash
        self.lastSnapshotHash = newHash
    }

    // MARK: ChordPro language and snippets

    static func setupLanguage(buffer: ViewStorage, language: Language) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            gtk_source_language_manager_append_search_path(manager, path)
            path.withCString { codeeditor_snippets($0) }
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.opaquePointer?.cast(), lang)
    }
}

// MARK: - Snippets

func handleSnippets(controller: SourceViewController) {
    let view: UnsafeMutablePointer<GtkSourceView>? = controller.storage.opaquePointer?.cast()
    controller.snippetsAvailable = bracket_condition_met(view) == 1
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
    let source: guint = codeeditor_timeout_add(
        500,
        flush_snapshot_cb,
        Unmanaged.passUnretained(controller).toOpaque()
    )
    /// Schedule new snapshot
    controller.snapshotSchedule = source
}

// MARK: - Swift callbacks for `C` functions

@_cdecl("codeeditor_insert_cb")
func codeeditor_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnapshot(controller)
}

@_cdecl("codeeditor_delete_cb")
func codeeditor_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnapshot(controller)
}

@_cdecl("cursor_position_cb")
func cursor_position_cb(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    let controller = Unmanaged<SourceViewController>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnippetCheck(controller)
}

@_cdecl("flush_snapshot_cb")
func flush_snapshot_cb(_ userData: UnsafeMutableRawPointer?) {
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
        let binding = controller.storage.fields["textBinding"] as? Binding<String>
    else {
        return
    }
    let text = snapshotText(buffer: buffer)
    binding.wrappedValue = text
    controller.lastSnapshotHash = text.hashValue
}

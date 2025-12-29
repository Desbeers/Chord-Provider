//
//  SourceView.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CCodeEditor

/// A text or code editor widget.
public struct SourceView: AdwaitaWidget {

    /// The editor's content.
    @Binding var text: String
    var padding = 0
    var paddingEdges: Set<Edge> = []
    var numbers = false
    var language: Language = .plain
    var wrapMode: WrapMode = .none
    var highlightCurrentLine: Bool = true
    var editable: Bool = true

    nonisolated(unsafe) private static var sourceInited = false

    public init(text: Binding<String>) {
        self._text = text
    }

    public func container<Data>(
        data: WidgetData,
        type: Data.Type
    ) -> ViewStorage {
        let buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())

        codeeditor_buffer_set_theme_adaptive(buffer.opaquePointer?.cast())
        setLanguage(buffer: buffer)

        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), text, -1)

        let storage = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.opaquePointer?.cast())?.opaque(),
            content: ["buffer": [buffer]]
        )

        if !Self.sourceInited {
            gtk_source_init()
            Self.sourceInited = true
        }

        // --- Snippets setup ---
        let snippets = gtk_source_completion_snippets_new()
        storage.fields["snippets"] = snippets
        storage.fields["snippetsActive"] = false
        storage.fields["lastSnapshotHash"] = text.hashValue

        // Store binding
        storage.fields["textBinding"] = self.$text
        storage.fields["dirty"] = false
        storage.fields["snapshotSource"] = guint(0)

        storage.fields["snippetIdle"] = nil

        /// Connect signal callbacks
        codeeditor_connect_buffer_signals(
            buffer.opaquePointer?.cast(),
            codeeditor_insert_cb,
            codeeditor_delete_cb,
            cursor_position_cb,
            Unmanaged.passUnretained(storage).toOpaque()
        )

        return storage
    }

    public func update<Data>(
        _ storage: ViewStorage,
        data: WidgetData,
        updateProperties: Bool,
        type: Data.Type
    ) {
        if updateProperties {
            /// Debounced sync
            Idle {
                syncFromSwiftIfNeeded(storage: storage)
                if paddingEdges.contains(.top) {
                    gtk_text_view_set_top_margin(storage.opaquePointer?.cast(), padding.cInt)
                }
                if paddingEdges.contains(.bottom) {
                    gtk_text_view_set_bottom_margin(storage.opaquePointer?.cast(), padding.cInt)
                }
                if paddingEdges.contains(.leading) {
                    gtk_text_view_set_left_margin(storage.opaquePointer?.cast(), padding.cInt)
                }
                if paddingEdges.contains(.trailing) {
                    gtk_text_view_set_right_margin(storage.opaquePointer?.cast(), padding.cInt)
                }
                gtk_text_view_set_editable(storage.opaquePointer?.cast(), editable.cBool)
                gtk_source_view_set_show_line_numbers(storage.opaquePointer?.cast(), numbers.cBool)
                gtk_text_view_set_wrap_mode(storage.opaquePointer?.cast(), wrapMode.rawValue)
                gtk_source_view_set_highlight_current_line(storage.opaquePointer?.cast(), highlightCurrentLine.cBool)
            }
            storage.previousState = self
        }
    }

    // MARK: ChordPro language and snippets

    func setLanguage(buffer: ViewStorage) {
        let manager = gtk_source_language_manager_get_default()
        if let urlPath = Bundle.module.url(forResource: "chordpro", withExtension: "lang") {
            let path = urlPath.deletingLastPathComponent().path()
            gtk_source_language_manager_append_search_path(manager, path)
            path.withCString { codeeditor_snippets($0) }
        }
        let lang = gtk_source_language_manager_get_language(manager, language.languageName)
        gtk_source_buffer_set_language(buffer.opaquePointer?.cast(), lang)
    }

    // MARK: Sync / Snapshots

    func syncFromSwiftIfNeeded(storage: ViewStorage) {
        guard
            let buffer = storage.content["buffer"]?.first,
            let binding = storage.fields["textBinding"] as? Binding<String>,
            let lastHash = storage.fields["lastSnapshotHash"] as? Int
        else { return }

        let newValue = binding.wrappedValue
        let newHash = newValue.hashValue

        guard newHash != lastHash else { return }

        gtk_text_buffer_set_text(buffer.opaquePointer?.cast(), newValue, -1)
        storage.fields["lastSnapshotHash"] = newHash
    }

    // MARK: View modifiers

    public func innerPadding(_ padding: Int = 10, edges: Set<Edge> = .all) -> Self {
        var newSelf = self
        newSelf.padding = padding
        newSelf.paddingEdges = edges
        return newSelf
    }

    public func lineNumbers(_ visible: Bool = true) -> Self {
        var newSelf = self
        newSelf.numbers = visible
        return newSelf
    }

    public func editable(_ editable: Bool = true) -> Self {
        var newSelf = self
        newSelf.editable = editable
        return newSelf
    }

    public func highlightCurrentLine(_ highlight: Bool = true) -> Self {
        var newSelf = self
        newSelf.highlightCurrentLine = highlight
        return newSelf
    }

    public func language(_ language: Language) -> Self {
        var newSelf = self
        newSelf.language = language
        return newSelf
    }

    public func wrapMode(_ mode: WrapMode) -> Self {
        var newSelf = self
        newSelf.wrapMode = mode
        return newSelf
    }
}

// MARK: - Helpers

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

func scheduleSnapshot(_ storage: ViewStorage) {
    storage.fields["dirty"] = true

    if let source = storage.fields["snapshotSource"] as? guint, source != 0,
       let gsource = g_main_context_find_source_by_id(nil, source) {
        g_source_destroy(gsource)
        storage.fields["snapshotSource"] = 0
    }

    let source: guint = codeeditor_timeout_add(
        200,
        flush_snapshot_cb,
        Unmanaged.passUnretained(storage).toOpaque()
    )

    storage.fields["snapshotSource"] = source
}


// MARK: - Snippets

func handleSnippets(storage: ViewStorage) {
    guard
        let snippets = storage.fields["snippets"] as? UnsafeMutablePointer<GtkSourceCompletionSnippets>,
        let active = storage.fields["snippetsActive"] as? Bool
    else { return }

    let view: UnsafeMutablePointer<GtkSourceView>? = storage.opaquePointer?.cast()
    let completion = gtk_source_view_get_completion(view)
    let bracket = bracket_condition_met(view) == 1

    if bracket {
        if !active {
            storage.fields["snippetsActive"] = true
            gtk_source_completion_add_provider(completion, snippets.opaque())
        }
    } else if active {
        gtk_source_completion_hide(completion)
        gtk_source_completion_remove_provider(completion, snippets.opaque())
        storage.fields["snippetsActive"] = false
    }
}

func scheduleSnippetCheck(_ storage: ViewStorage) {
    if storage.fields["snippetIdle"] != nil { return }
    storage.fields["snippetIdle"] = Idle {
        storage.fields["snippetIdle"] = nil
        handleSnippets(storage: storage)
    }
}

// MARK: - Swift callbacks for `C` functions

@_cdecl("codeeditor_insert_cb")
func codeeditor_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let storage = Unmanaged<ViewStorage>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnapshot(storage)
}

@_cdecl("codeeditor_delete_cb")
func codeeditor_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let userData else { return }
    let storage = Unmanaged<ViewStorage>.fromOpaque(userData).takeUnretainedValue()
    scheduleSnapshot(storage)
}

@_cdecl("cursor_position_cb")
func cursor_position_cb(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    let storage = Unmanaged<ViewStorage>
        .fromOpaque(userData)
        .takeUnretainedValue()

    scheduleSnippetCheck(storage)
}

@_cdecl("flush_snapshot_cb")
func flush_snapshot_cb(_ userData: UnsafeMutableRawPointer?) {
    guard let userData else { return }
    let storage = Unmanaged<ViewStorage>.fromOpaque(userData).takeUnretainedValue()
    storage.fields["snapshotSource"] = 0
    guard storage.fields["dirty"] as? Bool == true else { return }
    storage.fields["dirty"] = false

    guard
        let buffer = storage.content["buffer"]?.first,
        let binding = storage.fields["textBinding"] as? Binding<String>
    else { return }

    let text = snapshotText(buffer: buffer)
    binding.wrappedValue = text
    storage.fields["lastSnapshotHash"] = text.hashValue
}

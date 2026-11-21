//
//  Editor+Controller.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceEditor
import CLibSpelling

extension Editor {

    /// The controller for the `GtkSourceView`.
    @MainActor
    public final class Controller {

        /// The GTKSourceView.
        let view: ViewStorage
        /// The GTKTextBuffer.
        let buffer: ViewStorage
        /// Search settings.
        let searchSettings: ViewStorage
        /// Search context.
        let searchContext: ViewStorage
        /// Scheme.
        public var scheme: Binding<Editor.Scheme> = .constant(.init("Adwaita"))
        /// Bridge.
        public var bridge: Binding<Editor.Bridge> = .constant(Editor.Bridge())
        /// Resources.
        let resources: URL?
        /// The GtkSourceFile, which keeps the detected encoding and newline type.
        var file = gtk_source_file_new()

        // MARK: Snippets

        /// The snippets provider.
        let snippets = gtk_source_completion_snippets_new()
        /// Bool if we should show snippets.
        /// - Note: Show them when a line starts with a `{` and the line does not contain the closing bracket `}`.
        var snippetsAvailable: Bool = false
        /// Bool if the snippets are loaded in the completion provider.
        var snippetsLoaded: Bool = false
        /// Idle handling of adding snippets.
        var snippetsIdle: Idle?
        /// The completion object.
        let completion: OpaquePointer?

        // MARK: Debouncers

        /// Line number debounce.
        let lineNumberDebounce = Debouncer(delay: 0.1)
        /// Snapshot debounce.
        let snapshotDebounce = Debouncer(delay: 0.5)

        // MARK: Callbacks

        /// Callback on change of text.
        var onTextChanged: ((String) -> [SourceMark])?
        /// Callback on change of line.
        var onLineChanged: (() -> Void)?
        /// Callback when triple click a line.
        var onTripleClick: (() -> Void)?
        /// Callback on change of scheme.
        var onSchemeChanged: (() -> Void)?
        /// Callback on new
        var onNew: (() -> Void)?
        /// Callback on open
        var onOpen: ((Result<URL, Error>) -> Void)?
        /// Callback on save
        var onSave: ((Result<URL, Error>) -> Void)?

        /// Init the controller.
        public init(resources: URL? = nil) {
            self.resources = resources
            if let resources {
                let manager = Editor.Controller.languageManager
                gtk_source_language_manager_append_search_path(manager, resources.path)
                Editor.Controller.addSnippetsPath(resources.path)
            }
            // Do this first, or else you are in trouble!
            gtk_source_init()
            buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
            searchSettings = ViewStorage(gtk_source_search_settings_new().opaque())
            gtk_source_search_settings_set_wrap_around(searchSettings.searchSettingsPointer, 1)
            searchContext = ViewStorage(
                gtk_source_search_context_new(
                    buffer.sourceBufferPointer,
                    searchSettings.searchSettingsPointer
                )
            )
            view = ViewStorage(
                gtk_source_view_new_with_buffer(buffer.sourceBufferPointer).opaque(),
                content: ["buffer": [buffer]]
            )
            gtk_widget_add_css_class(view.widgetPointer, "source-editor")
            // Give text some breathing space.
            gtk_text_view_set_pixels_above_lines(view.textViewPointer, 4)
            gtk_text_view_set_pixels_below_lines(view.textViewPointer, 4)
            gtk_text_view_set_pixels_inside_wrap(view.textViewPointer, 4)
            // Snippets
            completion = gtk_source_view_get_completion(view.sourceEditorPointer)
            // Style
            initStyle(resources: resources)
            // Spelling
            let spellingAdapter = spelling_text_buffer_adapter_new(
                buffer.sourceBufferPointer,
                spelling_checker_get_default()
            )
            gtk_text_view_set_extra_menu(
                view.textViewPointer,
                spelling_text_buffer_adapter_get_menu_model(spellingAdapter)
            )
            gtk_widget_insert_action_group(
                view.widgetPointer,
                "spelling",
                spellingAdapter
            )
            view.content["spelling"] = [ViewStorage(spellingAdapter)]

            // Connect signal callbacks
            sourceview_connect_signals(
                view.sourceEditorPointer,
                sourceview_insert_cb,
                sourceview_delete_cb,
                sourceview_click_cb,
                sourceview_key_cb,
                Unmanaged.passUnretained(self).toOpaque()
            )

            buffer.notify(name: "cursor-position") {
                self.lineNumberDebounce.schedule {
                    self.updateCurrentLine()
                    self.scheduleSnippetCheck()
                }
            }

            buffer.connectSignal(name: "modified-changed") { [self] in
                let modified = gtk_text_buffer_get_modified(buffer.textBufferPointer) != 0
                bridge.modified.wrappedValue = modified
            }

            searchContext.notify(name: "occurrences-count") {
                if !self.bridge.search.search.wrappedValue.isEmpty {
                    self.matchesCount()
                }
            }
        }
    }
}
// MARK: - Swift callbacks for `C` functions

// swiftlint:disable unused_parameter

extension Editor.Controller {

    /// Helper to get the controller for 'C' callbacks.
    /// - Parameter userData: The user data.
    /// - Returns: The controller.
    nonisolated static func controller(from userData: UnsafeMutableRawPointer?) -> Editor.Controller? {
        guard let userData else {
            return nil
        }
        return Unmanaged<Editor.Controller>
            .fromOpaque(userData)
            .takeUnretainedValue()
    }
}

/// Handle insert event.
@_documentation(visibility: private)
@_cdecl("sourceview_insert_cb")
func sourceview_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = Editor.Controller.controller(from: userData) else {
        return
    }
    MainActor.assumeIsolated {
        controller.scheduleSnapshot()
    }
}

/// Handle delete event.
@_documentation(visibility: private)
@_cdecl("sourceview_delete_cb")
func sourceview_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = Editor.Controller.controller(from: userData) else {
        return
    }
    MainActor.assumeIsolated {
        controller.scheduleSnapshot()
    }
}

/// Handle click event.
@_documentation(visibility: private)
@_cdecl("sourceview_click_cb")
func sourceview_click_cb(
    click: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard
        click == 3,
        let controller = Editor.Controller.controller(from: userData)
    else {
        return
    }
    MainActor.assumeIsolated {
        controller.onTripleClick?()
    }
}

/// Handle key event.
@_documentation(visibility: private)
@_cdecl("sourceview_key_cb")
func sourceview_key_cb(
    keyval: UInt32,
    keycode: UInt32,
    state: GdkModifierType,
    userData: UnsafeMutableRawPointer?
) -> gboolean {
    guard
        state.rawValue == 0,
        keyval == UInt32(GDK_KEY_bracketleft),
        let controller = Editor.Controller.controller(from: userData)
    else {
        return 0
    }
    return MainActor.assumeIsolated {
        guard let buffer = controller.buffer.textBufferPointer else {
            return 0
        }
        gtk_text_buffer_insert_at_cursor(buffer, "[]", -1)
        var iter = controller.cursorPosition
        gtk_text_iter_backward_char(&iter)
        gtk_text_buffer_place_cursor(buffer, &iter)
        // Return 1 because the bracket is already handled now
        return 1
    }
}

// swiftlint:enable unused_parameter

//
//  SourceViewController.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView

/// The controller for the `GtkSourceView`
@MainActor
public final class SourceViewController {

    /// The GTKSourceView
    let view: ViewStorage
    /// The GTKTextBuffer
    let buffer: ViewStorage
    /// Search settings
    let searchSettings: ViewStorage
    /// Search context
    let searchContext: ViewStorage

    // MARK: Snippets

    /// The snippets provider
    let snippets = gtk_source_completion_snippets_new()
    /// Bool if we should show snippets
    /// - Note Show them when a line starts with a `{` and the line does not contain the closing bracket `}`
    var snippetsAvailable: Bool = false
    /// Bool if the snippets are loaded in the completion provider
    var snippetsLoaded: Bool = false
    /// Idle handling of adding snippets
    var snippetsIdle: Idle?
    /// The completion object
    let completion: OpaquePointer?

    // MARK: Debouncers

    /// Line number debounce
    let lineNumberDebounce = Debouncer(delay: 0.1)
    /// Snapshot debounce
    let snapshotDebounce = Debouncer(delay: 0.5)

    // MARK: Callbacks

    /// Callback on change of text
    var onTextChanged: ((String) -> [SourceMark])?
    /// Callback on change of line
    var onLineChanged: (() -> Void)?
    /// Callback when triple click a line
    var onTripleClick: (() -> Void)?

    /// Init the controller
    /// - Parameter language: The editor language
    public init() {

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
            content: ["buffer": [buffer], "searchSettings": [searchSettings], "searchContext": [searchContext]]
        )

        // MARK: Snippets

        completion = gtk_source_view_get_completion(view.sourceViewPointer)

        // MARK: Style

        SourceViewController.initStyle(
            view: view,
            buffer: buffer
        )

        gtk_source_init()

        // MARK: Connect signal callbacks

        sourceview_connect_signals(
            view.sourceViewPointer,
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

        searchContext.notify(name: "occurrences-count") {
            guard let bridge = self.bridgeBinding else {
                return
            }
            if !bridge.search.search.wrappedValue.isEmpty {
                self.matchesCount()
            }
        }
    }
}

// MARK: - Swift callbacks for `C` functions

// swiftlint:disable unused_parameter

extension SourceViewController {

    /// Helper to get the controller for 'C' callbacks
    /// - Parameter userData: The user data
    /// - Returns: The controller
    nonisolated static func controller(from userData: UnsafeMutableRawPointer?) -> SourceViewController? {
        guard let userData else {
            return nil
        }
        return Unmanaged<SourceViewController>
            .fromOpaque(userData)
            .takeUnretainedValue()
    }
}

/// Handle insert event
@_documentation(visibility: private)
@_cdecl("sourceview_insert_cb")
func sourceview_insert_cb(
    offset: Int32,
    text: UnsafePointer<CChar>?,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = SourceViewController.controller(from: userData) else {
        return
    }
    MainActor.assumeIsolated {
        controller.scheduleSnapshot()
    }
}

/// Handle delete event
@_documentation(visibility: private)
@_cdecl("sourceview_delete_cb")
func sourceview_delete_cb(
    start: Int32,
    end: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard let controller = SourceViewController.controller(from: userData) else {
        return
    }
    MainActor.assumeIsolated {
        controller.scheduleSnapshot()
    }
}

/// Handle click event
@_documentation(visibility: private)
@_cdecl("sourceview_click_cb")
func sourceview_click_cb(
    click: Int32,
    userData: UnsafeMutableRawPointer?
) {
    guard
        click == 3,
        let controller = SourceViewController.controller(from: userData)
    else {
        return
    }

    MainActor.assumeIsolated {
        if let onTripleClick = controller.onTripleClick {
            onTripleClick()
        }
    }
}

/// Handle key event
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
        let controller = SourceViewController.controller(from: userData)
    else {
        return 0
    }
    return MainActor.assumeIsolated {
        guard
            let buffer = controller.buffer.textBufferPointer
        else {
            return 0
        }
        gtk_text_buffer_insert_at_cursor(buffer, "[", -1)
        gtk_text_buffer_insert_at_cursor(buffer, "]", -1)
        var iter = controller.cursorPosition
        gtk_text_iter_backward_char(&iter)
        gtk_text_buffer_place_cursor(buffer, &iter)
        // Return 1 because the bracket is already handled now
        return 1
    }
}

// swiftlint:enable unused_parameter

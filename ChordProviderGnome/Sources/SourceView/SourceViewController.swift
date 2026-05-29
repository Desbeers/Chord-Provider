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
    let view: ViewStorage
    /// The GTKTextBuffer
    let buffer: ViewStorage
    /// Search settings
    public let searchSettings: ViewStorage
    /// Search context
    public let searchContext: ViewStorage
    var currentSearchIter = GtkTextIter()
    /// The current line in the editor
    var currentLine = Song.Section.Line()
    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false
    /// Bool if the editor has a selection
    public var hasSelection: Bool = false
    // /// Current search
    // var searchState = SearchState()

    // MARK: Snippets

    /// The snippets provider
    let snippets = gtk_source_completion_snippets_new()
    /// Bool if we should show snippets
    /// - Note Show them when a line starts with a `{` and the line does not contain the closing bracvket `}`
    var snippetsAvailable: Bool = false
    /// Bool if the snippets are loaded in the completion provider
    var snippetsLoaded: Bool = false
    /// Idle handling of adding snippets
    var snippetsIdle: Idle?
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

        buffer = ViewStorage(gtk_source_buffer_new(nil)?.opaque())
        searchSettings = ViewStorage(gtk_source_search_settings_new().opaque())

        gtk_source_search_settings_set_wrap_around(searchSettings.opaquePointer?.cast(), 1)
        searchContext = ViewStorage(
            gtk_source_search_context_new(
                buffer.sourceBufferPointer,
                searchSettings.opaquePointer?.cast()
            )
        )
        view = ViewStorage(
            gtk_source_view_new_with_buffer(buffer.sourceBufferPointer).opaque(),
            content: ["buffer": [buffer], "searchSettings": [searchSettings], "searchContext": [searchContext]]
        )
        // Store the binding of the bridge
        view.fields["bridge"] = bridge

        // MARK: Snippets

        completion = gtk_source_view_get_completion(view.sourceViewPointer)

        // MARK: Style

        SourceViewController.initStyle(
            view: view,
            buffer: buffer,
            language: language
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

        searchHighlight(false)
    }
}

// MARK: - Swift callbacks for `C` functions

extension SourceViewController {

    /// Get  string from the buffer
    /// - Parameters:
    ///   - start: Start iterator
    ///   - end: End iterator
    /// - Returns: An optional String
    func stringFromBuffer(start: inout GtkTextIter, end: inout GtkTextIter)-> String? {
        guard let cString = gtk_text_buffer_get_text(
            buffer.textBufferPointer,
            &start,
            &end,
            0
        ) else {
            return nil
        }
        // Free memory on return
        defer {
            g_free(cString)
        }
        return String(cString: cString)
    }

    /// The current text iterator
    func currentTextIter() -> GtkTextIter {
        var iter = GtkTextIter()
        guard let buffer = buffer.textBufferPointer else { return iter }
        let textMark = gtk_text_buffer_get_insert(buffer)
        gtk_text_buffer_get_iter_at_mark(buffer, &iter, textMark)
        return iter
    }

    /// Helper to get the controller for 'C' callbacks
    /// - Parameter userData: The user data
    /// - Returns: The controller
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
    guard 
        click == 3,
        let controller = SourceViewController.controller(from: userData),
        let binding = controller.view.fields["bridge"] as? Binding<SourceViewBridge>
    else {
        return
    }
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
    guard
        state.rawValue == 0,
        keyval == UInt32(GDK_KEY_bracketleft),
        let controller = SourceViewController.controller(from: userData),
        let buffer = controller.buffer.textBufferPointer
    else {
        return 0
    }
    gtk_text_buffer_insert_at_cursor(buffer, "[", -1)
    gtk_text_buffer_insert_at_cursor(buffer, "]", -1)
    var iter = controller.currentTextIter()
    gtk_text_iter_backward_char(&iter)
    gtk_text_buffer_place_cursor(buffer, &iter)
    // Return 1 because the bracket is already handled now
    return 1
}

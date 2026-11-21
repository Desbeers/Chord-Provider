//

//  Editor+Controller+helpers.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import CGtkSourceView

extension Editor.Controller {

    // MARK: Position and ranges

    /// The current cursor position.
    /// - Returns: The cursor iterator.
    var cursorPosition: GtkTextIter {
        var iter = GtkTextIter()
        guard let buffer = buffer.textBufferPointer else {
            return iter
        }
        let textMark = gtk_text_buffer_get_insert(buffer)
        gtk_text_buffer_get_iter_at_mark(buffer, &iter, textMark)
        return iter
    }

    /// Get the total range of the text buffer.
    /// - Returns: The start and end iterators.
    var bufferRange: (start: GtkTextIter, end: GtkTextIter) {
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer.textBufferPointer, &start)
        gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &end)
        return (start, end)
    }

    /// Get the range of the current selection.
    /// - Returns: Start and end as GtkTextIter's.
    var selectedRange: (start: GtkTextIter, end: GtkTextIter)? {
        var start = GtkTextIter()
        var end = GtkTextIter()
        guard gtk_text_buffer_get_selection_bounds(
            buffer.textBufferPointer,
            &start,
            &end
        ) != 0 else {
            return nil
        }
        return (start, end)
    }

    // MARK: Content getters

    /// Public getter for the text in the buffer.
    public var text: String {
        bufferText
    }

    /// Get all text from the buffer.
    /// - Returns: A String with the content.
    var bufferText: String {
        var range = bufferRange
        return bufferString(start: &range.start, end: &range.end) ?? ""
    }

    /// Get a string from the buffer.
    /// - Parameters:
    ///   - start: The start iterator.
    ///   - end: The end iterator.
    /// - Returns: An optional String.
    func bufferString(start: inout GtkTextIter, end: inout GtkTextIter) -> String? {
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

    /// Get the selected text from the buffer.
    /// - Returns: An optional String.
    var selectedText: String? {
        guard var range = selectedRange else {
            return nil
        }
        return bufferString(start: &range.start, end: &range.end)
    }

    // MARK: Text selection

    /// Clear any active selection in the text buffer.
    func clearSelection() {
        guard let buffer = buffer.textBufferPointer, var range = selectedRange else {
            return
        }
        // Collapse selection by placing cursor at the start of the selection
        gtk_text_buffer_place_cursor(buffer, &range.start)
    }

    // MARK: Cursor movement

    /// Move the cursor to the first line of the content and scroll to it.
    func moveCursorToFirstLine() {
        guard let buffer = buffer.textBufferPointer else {
            return
        }
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer, &iter)
        gtk_text_buffer_place_cursor(buffer, &iter)
        scrollToCursor()
    }

    /// Scroll to the current cursor position.
    func scrollToCursor() {
        guard let buffer = buffer.textBufferPointer else {
            return
        }
        let insertMark = gtk_text_buffer_get_insert(buffer)
        gtk_text_view_scroll_mark_onscreen(
            view.textViewPointer,
            insertMark
        )
    }

    // MARK: Resources

    /// The resources URL.
    public static var resourcesURL: URL {
        Bundle.module.resourceURL ?? URL(filePath: "")
    }

    // MARK: GObject properties

    /// The `GType` of a boolean; `G_TYPE_BOOLEAN` is a macro that Swift does not import.
    private static let gTypeBoolean = GType(5 << 2)
    /// The `GType` of a string; `G_TYPE_STRING` is a macro that Swift does not import.
    private static let gTypeString = GType(16 << 2)

    /// Get a bool property.
    func boolProperty(_ object: UnsafeMutablePointer<GObject>, _ name: String) -> Bool {
        var value = GValue()
        g_value_init(&value, Self.gTypeBoolean)
        defer { g_value_unset(&value) }
        g_object_get_property(object, name, &value)
        return g_value_get_boolean(&value) != 0
    }

    /// Get a string property.
    func stringProperty(_ object: UnsafeMutablePointer<GObject>, _ name: String) -> String? {
        var value = GValue()
        g_value_init(&value, Self.gTypeString)
        defer { g_value_unset(&value) }
        g_object_get_property(object, name, &value)
        guard let cString = g_value_get_string(&value) else {
            return nil
        }
        return String(cString: cString)
    }
}

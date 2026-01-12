//
//  SourceViewController+commands.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView
import ChordProviderCore

/// Command to pass to the editor
public enum SourceViewCommand {
    /// Insert a `Directive` at the cursor position
    case insertDirective(directive: ChordPro.Directive)
    /// Replace all text
    case replaceAllText(text: String)
    /// Append text to the end of the source
    case appendText(text: String)
    /// Replace all text on a specific line in the editor
    case replaceLineText(text: String)
    /// Clear the current selection
    case clearSelection
    /// Schedule to update the song
    case updateSong
}

extension SourceViewController {

    // MARK: Command handler

    func handle(_ command: SourceViewCommand) {
        switch command {
        case let .insertDirective(directive):
            insertDirective(directive)
        case .replaceAllText(text: let text):
            /// Clear all markers
            sourceview_clear_marks(buffer.opaquePointer?.cast(), "bookmark")
            replaceAllText(buffer.opaquePointer?.cast(), text)
            SourceViewController.moveCursorToFirstLine(storage: storage, buffer: buffer)
        case .appendText(text: let text):
            appendTextAndScroll(storage.opaquePointer?.cast(), text)
        case .replaceLineText(text: let text):
            clearSelection(buffer.opaquePointer?.cast())
            replaceFromCursorToNewline(buffer.opaquePointer?.cast(), text: text)
        case .clearSelection:
            clearSelection(buffer.opaquePointer?.cast())
        case .updateSong:
            scheduleSnapshot(self)
        }
        /// Refocus the editor
        /// - Note: It will loose focus because handling is done with a button
        gtk_widget_grab_focus(storage.opaquePointer?.cast())
    }

    /// Clear any active selection in the text buffer
    func clearSelection(_ buffer: UnsafeMutablePointer<GtkTextBuffer>?) {
        guard let buffer else { return }

        var insertIter = GtkTextIter()

        // Get the current cursor (insert mark) position
        let insertMark = gtk_text_buffer_get_insert(buffer)
        gtk_text_buffer_get_iter_at_mark(buffer, &insertIter, insertMark)

        // Collapse selection by placing cursor at insert position
        gtk_text_buffer_place_cursor(buffer, &insertIter)
    }

    // MARK: Command functions

    /// Replace all text in the editor
    /// - Parameters:
    ///   - buffer: The `GtkTextBuffer`
    ///   - text: The replacement `String`
    func replaceAllText(
        _ buffer: UnsafeMutablePointer<GtkTextBuffer>?,
        _ text: String
    ) {

        guard let buffer else { return }

        var start = GtkTextIter()
        var end = GtkTextIter()

        gtk_text_buffer_begin_user_action(buffer)

        gtk_text_buffer_get_start_iter(buffer, &start)
        gtk_text_buffer_get_end_iter(buffer, &end)

        gtk_text_buffer_delete(buffer, &start, &end)

        text.withCString { cString in
            gtk_text_buffer_insert(
                buffer,
                &start,
                cString,
                -1
            )
        }

        gtk_text_buffer_end_user_action(buffer)
    }

    /// Replace text from the cursor position up to (but not including) the first newline
    func replaceFromCursorToNewline(
        _ buffer: UnsafeMutablePointer<GtkTextBuffer>?,
        text: String
    ) {
        guard let buffer else { return }

        var start = GtkTextIter()
        var end = GtkTextIter()

        gtk_text_buffer_begin_user_action(buffer)

        // Get cursor position
        let insertMark = gtk_text_buffer_get_insert(buffer)
        gtk_text_buffer_get_iter_at_mark(buffer, &start, insertMark)

        // Find end of line by asking GTK directly
        let line = gtk_text_iter_get_line(&start)
        gtk_text_buffer_get_iter_at_line_offset(
            buffer,
            &end,
            line,
            Int32.max
        )

        // Delete everything up to the newline
        gtk_text_buffer_delete(buffer, &start, &end)

        // Insert replacement text at cursor
        text.withCString {
            gtk_text_buffer_insert_at_cursor(buffer, $0, -1)
        }

        gtk_text_buffer_end_user_action(buffer)
    }







    /// Insert a directive in the editor at the cursor position
    /// - Parameter directive: The `Directive` to add
    func insertDirective(_ directive: ChordPro.Directive) {
        /// Close the *undo* group*
        defer {
            gtk_text_buffer_end_user_action(buffer.opaquePointer?.cast())
        }
        /// Make sure we get the buffer
        guard let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> =
            buffer.opaquePointer?.cast()
        else {
            return
        }
        /// Make it one `undo` group
        gtk_text_buffer_begin_user_action(bufferPtr)

        var insertIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            bufferPtr,
            &insertIter,
            gtk_text_buffer_get_insert(bufferPtr)
        )

        /// Get the start and end values for the directive
        var directiveStart = directive.format.start
        var directiveEnd = directive.format.end

        // MARK: Insert without a selection

        /// No selection: insert prefix + suffix and move cursor
        if gtk_text_buffer_get_has_selection(bufferPtr) == 0 {

            /// *Repeat chorus* is an exception; it has no *start* and *end`* but it *is* and environment
            /// - Note: Give it additional *newlines* because the cursor will be moved
            if directive == .chorus {
                directiveEnd += "\n\n"
            }

            // Move to start of the current line
            gtk_text_iter_set_line_offset(&insertIter, 0)

            // Insert prefix first
            gtk_text_buffer_insert(bufferPtr, &insertIter, directiveStart, -1)

            // Insert suffix last
            gtk_text_buffer_insert(bufferPtr, &insertIter, "\(directiveEnd)\n", -1)

            /// Move cursor
            var cursorIter = GtkTextIter()
            gtk_text_buffer_get_iter_at_mark(bufferPtr, &cursorIter, gtk_text_buffer_get_insert(bufferPtr))

            if ChordPro.Directive.environmentDirectives.contains(directive) {
                /// Move the cursor up two lines to be in between the directives
                gtk_text_iter_backward_line(&cursorIter)
                gtk_text_iter_backward_line(&cursorIter)
            } else {
                /// Move it back just before the bracket
                gtk_text_iter_backward_char(&cursorIter)
                gtk_text_iter_backward_char(&cursorIter)
            }
            gtk_text_buffer_place_cursor(bufferPtr, &cursorIter)

            return
        }

        // MARK: Insert with a selection

        /// *Repeat chorus* is an exception; it has no *start* and *end`* but it *is* and environment
        /// - Note: Add the selection as its label so give it some space
        if directive == .chorus {
            directiveStart += " "
        }

        /// Selection case: wrap selection with prefix/suffix
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_selection_bounds(bufferPtr, &start, &end)

        let startMark = gtk_text_buffer_create_mark(bufferPtr, nil, &start, 1)
        let endMark   = gtk_text_buffer_create_mark(bufferPtr, nil, &end, 0)

        // Insert suffix first
        var endIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &endIter, endMark)
        gtk_text_buffer_insert(bufferPtr, &endIter, "\(directiveEnd)\n", -1)

        // Insert prefix second
        var startIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &startIter, startMark)
        gtk_text_buffer_insert(bufferPtr, &startIter, directiveStart, -1)

        // Collapse selection
        var cursorIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &cursorIter, endMark)
        gtk_text_buffer_place_cursor(bufferPtr, &cursorIter)

        // Cleanup marks
        gtk_text_buffer_delete_mark(bufferPtr, startMark)
        gtk_text_buffer_delete_mark(bufferPtr, endMark)
    }

    func appendTextAndScroll(
        _ view: UnsafeMutablePointer<GtkSourceView>?,
        _ text: String
    ) {
        let buffer = gtk_text_view_get_buffer(UnsafeMutablePointer<GtkTextView>(OpaquePointer(view)))

        var end = GtkTextIter()

        gtk_text_buffer_begin_user_action(buffer)

        // Get end of buffer
        gtk_text_buffer_get_end_iter(buffer, &end)

        // Ensure we start on a new line
        if gtk_text_iter_starts_line(&end) == 0 {
            gtk_text_buffer_insert(buffer, &end, "\n", 1)
            gtk_text_buffer_get_end_iter(buffer, &end)
        }

        // Blank line BEFORE
        gtk_text_buffer_insert(buffer, &end, "\n", 1)
        gtk_text_buffer_get_end_iter(buffer, &end)

        // Insert text
        text.withCString { cString in
            gtk_text_buffer_insert(buffer, &end, cString, -1)
        }
        gtk_text_buffer_get_end_iter(buffer, &end)

        // Blank line AFTER
        gtk_text_buffer_insert(buffer, &end, "\n\n", 2)
        gtk_text_buffer_get_end_iter(buffer, &end)

        // Move cursor to end
        gtk_text_buffer_place_cursor(buffer, &end)

        gtk_text_buffer_end_user_action(buffer)

        // Scroll to cursor
        if let insertMark = gtk_text_buffer_get_insert(buffer) {
            gtk_text_view_scroll_mark_onscreen(
                UnsafeMutablePointer<GtkTextView>(OpaquePointer(view)),
                insertMark
            )
        }
    }

}

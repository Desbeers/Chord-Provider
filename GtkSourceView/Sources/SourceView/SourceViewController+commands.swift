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

public enum SourceViewCommand {
    case insertDirective(directive: ChordPro.Directive)
    case replaceAllText(text: String)
    case appendText(text: String)
}

extension SourceViewController {

    // MARK: Commands

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
        }
    }

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

    func insertDirective(_ directive: ChordPro.Directive) {
        defer {
            gtk_text_buffer_end_user_action(buffer.opaquePointer?.cast())
            /// Refocus the editor
            gtk_widget_grab_focus(storage.opaquePointer?.cast())
        }
        guard let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> =
            buffer.opaquePointer?.cast()
        else { return }
        /// Make it one `undo`
        gtk_text_buffer_begin_user_action(bufferPtr)

        var insertIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            bufferPtr,
            &insertIter,
            gtk_text_buffer_get_insert(bufferPtr)
        )

        /// No selection: insert prefix + suffix and move cursor
        if gtk_text_buffer_get_has_selection(bufferPtr) == 0 {
            // Move to start of the current line
            gtk_text_iter_set_line_offset(&insertIter, 0)

            // Insert prefix first
            gtk_text_buffer_insert(bufferPtr, &insertIter, directive.format.start, -1)

            // Insert suffix last
            gtk_text_buffer_insert(bufferPtr, &insertIter, "\(directive.format.end)\n", -1)

            // Move cursor two lines up
            var cursorIter = GtkTextIter()
            gtk_text_buffer_get_iter_at_mark(bufferPtr, &cursorIter, gtk_text_buffer_get_insert(bufferPtr))
            // Move iter backward by 2 lines

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

        /// Selection case: wrap selection with prefix/suffix
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_selection_bounds(bufferPtr, &start, &end)

        let startMark = gtk_text_buffer_create_mark(bufferPtr, nil, &start, 1)
        let endMark   = gtk_text_buffer_create_mark(bufferPtr, nil, &end, 0)

        // Insert suffix first
        var endIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &endIter, endMark)
        gtk_text_buffer_insert(bufferPtr, &endIter, "\(directive.format.end)\n", -1)

        // Insert prefix second
        var startIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &startIter, startMark)
        gtk_text_buffer_insert(bufferPtr, &startIter, directive.format.start, -1)

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

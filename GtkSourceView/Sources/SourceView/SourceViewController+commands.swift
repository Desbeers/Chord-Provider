//
//  SourceViewController+commands.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CCodeEditor

extension SourceViewController {

    // MARK: Commands

    func handle(_ command: SourceViewCommand) {
        switch command {
        case let .insert(text, wrapper):
            insertText(text, wrapSelectionWith: wrapper)
        case let .setMarker(line, category, enabled):
            setMarker(line: line, category: category, enabled: enabled)
        case .clearMarkers:
            codeeditor_clear_marks(buffer.opaquePointer?.cast(), "bookmark")
        case .setMarkers(lines: let lines):
            codeeditor_clear_marks(buffer.opaquePointer?.cast(), "bookmark")
            codeeditor_clear_annotations(annotations)
            for line in lines {
                setMarker(line: line.sourceLineNumber, category: "bookmark", enabled: true)
                if let warnings = line.warnings {
                    var text: String = ""
                    for warning in warnings {
                        text += warning.message
                        if warning != warnings.last {
                            text += "\n"
                        }
                    }
                    text.withCString { cString in
                        codeeditor_add_annotation(buffer.opaquePointer?.cast(), annotations, line.sourceLineNumber.cInt, cString)
                    }
                }
            }
        case .replaceAllText(text: let text):
            replaceAllText(buffer.opaquePointer?.cast(), text)
        case .appendText(text: let text):
            appendTextAndScroll(storage.opaquePointer?.cast(), text)
        }
    }

    func setMarker(
        line: Int,
        category: String,
        enabled: Bool
    ) {
        category.withCString { cat in
            if enabled {
                codeeditor_add_line_mark(buffer.opaquePointer?.cast(), line.cInt, cat)
            } else {
                codeeditor_remove_line_marks(buffer.opaquePointer?.cast(), line.cInt, cat)
            }
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

    func insertText(
        _ text: String,
        wrapSelectionWith wrapper: (prefix: String, suffix: String)? = nil
    ) {
        guard let bufferPtr: UnsafeMutablePointer<GtkTextBuffer> =
            buffer.opaquePointer?.cast()
        else { return }

        var insertIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(
            bufferPtr,
            &insertIter,
            gtk_text_buffer_get_insert(bufferPtr)
        )

        /// No selection = simple insert
        if wrapper == nil || (gtk_text_buffer_get_has_selection(bufferPtr) == 0) {
            gtk_text_buffer_insert(bufferPtr, &insertIter, text, -1)
            return
        }

        /// Selection case
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_selection_bounds(bufferPtr, &start, &end)

        let startMark = gtk_text_buffer_create_mark(bufferPtr, nil, &start, 1)
        let endMark   = gtk_text_buffer_create_mark(bufferPtr, nil, &end, 0)

        /// Insert suffix first
        var endIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &endIter, endMark)
        gtk_text_buffer_insert(bufferPtr, &endIter, wrapper!.suffix, -1)

        /// Insert prefix second
        var startIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &startIter, startMark)
        gtk_text_buffer_insert(bufferPtr, &startIter, wrapper!.prefix, -1)

        /// Clear selection by collapsing it
        var cursorIter = GtkTextIter()
        gtk_text_buffer_get_iter_at_mark(bufferPtr, &cursorIter, endMark)
        gtk_text_buffer_place_cursor(bufferPtr, &cursorIter)

        /// Cleanup
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

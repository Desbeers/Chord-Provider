//
//  Editor+Controller+commands.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor.Controller {

    /// Hande an editor command.
    public func command( _ command: Editor.Command) {
        handle(command)
    }

    // MARK: Command handler

    /// Handle a command for the editor.
    /// - Parameter command: The ``Editor.Command``.
    func handle(_ command: Editor.Command) {
        switch command {

        // MARK: File handlers

        case let .newFile(text, fileURL):
            if let fileURL {
                quessLanguage(fileURL: fileURL)
            }
            new(text)
            resetSearch()
            refocusEditor()
        case let .open(fileURL, completion):
            quessLanguage(fileURL: fileURL)
            open(fileURL, completion: completion ?? { _ in })
            resetSearch()
            refocusEditor()
        case let .save(fileURL):
            save(to: fileURL)
            resetSearch()
            refocusEditor()
        case .markAsUnmodified:
            markAsUnmodified()

        // MARK: Inserts

        case let .insertMarker(start, end, block):
            insertMarker(start: start, end: end, block: block)
            refocusEditor()
        case let .replaceAllText(text):
            replaceAllText(text)
            moveCursorToFirstLine()
            refocusEditor()
        case let .appendText(text):
            appendTextAndScroll(text)
            refocusEditor()
        case let .replaceLineText(text):
            clearSelection()
            replaceFromCursorToNewline(text: text)
            refocusEditor()

        // MARK: Search commands

        case let .search(direction):
            search(direction: direction)
        case let .replaceSearchMatch(replacement):
            replaceSearchMatch(with: replacement)
        case let .replaceAllSearchMatches(replacement):
            replaceAllSearchMatches(with: replacement)

        // MARK: Search options

        case let .regularExpressions(state):
            regularExpressions(state)
        case let .matchWholeWordOnly(state):
            matchWholeWordOnly(state)
        case let .caseSensitive(state):
            caseSensitive(state)

        // MARK: Other

        case .clearSelection:
            clearSelection()
        case .updateContent:
            scheduleSnapshot()
        }
    }

    /// Refocus the editor.
    /// - Note: It will lose focus when the command is handled with a button.
    private func refocusEditor() {
        gtk_widget_grab_focus(view.widgetPointer)
    }

    /// Group the action on one *undo* group.
    /// - Parameter action: The action to perform.
    private func withUndoGroup(_ action: () -> Void) {
        gtk_text_buffer_begin_user_action(buffer.textBufferPointer)
        defer {
            gtk_text_buffer_end_user_action(buffer.textBufferPointer)
        }

        action()
    }

    // MARK: Command functions

    /// Replace all the text in the editor.
    /// - Parameter text: The replacement `String`.
    private func replaceAllText(_ text: String) {
        withUndoGroup {
            var range = bufferRange
            gtk_text_buffer_delete(buffer.textBufferPointer, &range.start, &range.end)
            gtk_text_buffer_insert(buffer.textBufferPointer, &range.start, text, -1)
        }
    }

    /// Replace text from the cursor position up to (but not including) the first newline.
    /// - Parameter text: The replacement `String`.
    private func replaceFromCursorToNewline(text: String) {
        withUndoGroup {
            var start = cursorPosition

            // Delete everything up to the newline if the newline is not at the start
            // The int value of a newline character = 10
            if gtk_text_iter_get_char(&start) != 10 {
                var end = cursorPosition
                gtk_text_iter_forward_to_line_end(&end)
                gtk_text_buffer_delete(buffer.textBufferPointer, &start, &end)
            }

            // Insert replacement text at cursor
            gtk_text_buffer_insert_at_cursor(buffer.textBufferPointer, text, -1)
        }
    }

    /// Insert a marker in the editor at the cursor position.
    /// - Parameters:
    ///   - start: The start of the marker.
    ///   - end: The end of the marker.
    ///   - block: Bool if the marker is a block; this decides where the cursor ends up.
    private func insertMarker(start: String, end: String, block: Bool) {
        withUndoGroup {
            if gtk_text_buffer_get_has_selection(buffer.textBufferPointer) == 0 {
                insertDirectiveWithoutSelection()
            } else {
                insertDirectiveWithSelection()
            }

            // MARK: Insert without a selection

            /// Insert without a selection.
            @MainActor
            func insertDirectiveWithoutSelection() {
                var insertIter = cursorPosition

                // Move to start of the current line
                gtk_text_iter_set_line_offset(&insertIter, 0)

                let insert = "\(start)\(end)\n"
                // Insert the directive
                gtk_text_buffer_insert(buffer.textBufferPointer, &insertIter, insert, -1)

                // Move the cursor
                var cursorIter = cursorPosition

                if block {
                    // Move the cursor up two lines to be in between the directives
                    gtk_text_iter_backward_line(&cursorIter)
                    gtk_text_iter_backward_line(&cursorIter)
                } else {
                    // Move it back just before the bracket
                    gtk_text_iter_backward_char(&cursorIter)
                    gtk_text_iter_backward_char(&cursorIter)
                }
                gtk_text_buffer_place_cursor(buffer.textBufferPointer, &cursorIter)
            }

            // MARK: Insert with a selection

            /// Insert with a selection.
            @MainActor
            func insertDirectiveWithSelection() {
                guard let selection = selectedText, var range = selectedRange else {
                    return
                }
                let directiveString = "\(start)\(selection)\(end)\n"
                // Delete everything that is selected
                gtk_text_buffer_delete(buffer.textBufferPointer, &range.start, &range.end)
                // Insert the directive
                gtk_text_buffer_insert(buffer.textBufferPointer, &range.start, directiveString, -1)
            }
        }
    }

    /// Append text and scroll to its position.
    /// - Parameter text: The `String` to append.
    private func appendTextAndScroll(_ text: String) {
        withUndoGroup {
            var range = bufferRange
            // Ensure we start on a new line, then a blank line BEFORE the text and two AFTER
            let newline = gtk_text_iter_starts_line(&range.end) == 0 ? "\n" : ""
            let appended = "\(newline)\n\(text)\n\n"
            gtk_text_buffer_insert(buffer.textBufferPointer, &range.end, appended, -1)
            // Move cursor to end
            gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &range.end)
            gtk_text_buffer_place_cursor(buffer.textBufferPointer, &range.end)
            // Scroll to cursor
            scrollToCursor()
        }
    }
}

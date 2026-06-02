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
/// 
/// Important:
/// 
/// Always set or edit content with a *command*,
/// or else the text will be ignored.
/// 
/// Never touch the buffer content directly!
public enum SourceViewCommand {

    // MARK: Inserts

    /// Open new song
    case openNewSong(String)
    /// Insert a `Directive` at the cursor position
    case insertDirective(ChordPro.Directive)
    /// Replace all text
    case replaceAllText(String)
    /// Append text to the end of the source
    case appendText(String)
    /// Replace all text on a specific line in the editor
    case replaceLineText(String)

    // MARK: Search commands

    /// Search
    case search(SourceViewBridge.SearchDirection)
    /// Replace match
    case replaceSearchMatch(with: String)
    /// Replace all matches
    case replaceAllSearchMatches(with: String)

    // MARK: Search options
    
    /// Use regular expressions
    case regularExpressions(Bool)
    /// Search must match whole words
    case matchWholeWordOnly(Bool)
    /// Search is case sensitive
    case caseSensitive(Bool)

    // MARK: Other

    /// Clear the current selection
    case clearSelection
    /// Schedule to update the song
    case updateSong
}

extension SourceViewController {

    // MARK: Command handler

    /// Handle a command for the editor
    /// - Parameter command: The ``SourceViewCommand``
    func handle(_ command: SourceViewCommand) {
        switch command {

        // MARK: Inserts

        case let .openNewSong(text):
            replaceAllText(text)
            resetSearch()
            moveCursorToFirstLine()
            refocusEditor()
        case let .insertDirective(directive):
            insertDirective(directive)
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
        case .updateSong:
            scheduleSnapshot()
        }
    }

    /// Refocus the editor
    /// - Note: It will lose focus when the command is handled with a button
    private func refocusEditor() {
        gtk_widget_grab_focus(view.widgetPointer)
    }

    /// Group the action on one *undo* group
    /// - Parameter action: The action to perform
    private func withUndoGroup(_ action: () -> Void) {
        gtk_text_buffer_begin_user_action(buffer.textBufferPointer)
        defer {
            gtk_text_buffer_end_user_action(buffer.textBufferPointer)
        }

        action()
    }

    // MARK: Command functions

    /// Replace all the text in the editor
    /// - Parameter text: The replacement `String`
    private func replaceAllText(_ text: String) {
        withUndoGroup {
            var range = bufferRange
            gtk_text_buffer_delete(buffer.textBufferPointer, &range.start, &range.end)
            text.withCString { cString in
                gtk_text_buffer_insert(
                    buffer.textBufferPointer,
                    &range.start,
                    cString,
                    -1
                )
            }
        }
    }

    /// Replace text from the cursor position up to (but not including) the first newline
    /// - Parameter text: The replacement `String`
    private func replaceFromCursorToNewline(text: String) {
        withUndoGroup {
            var start = cursorPosition
            var end = cursorPosition

            // Find end of line
            gtk_text_iter_forward_to_line_end(&end)

            // Delete everything up to the newline
            gtk_text_buffer_delete(buffer.textBufferPointer, &start, &end)

            // Insert replacement text at cursor
            text.withCString {
                gtk_text_buffer_insert_at_cursor(buffer.textBufferPointer, $0, -1)
            }
        }
    }

    /// Insert a directive in the editor at the cursor position
    /// - Parameter directive: The `Directive` to add
    private func insertDirective(_ directive: ChordPro.Directive) {
        withUndoGroup {
            var insertIter = cursorPosition

            // Get the start and end values for the directive
            var directiveStart = directive.format.start
            var directiveEnd = directive.format.end

            if gtk_text_buffer_get_has_selection(buffer.textBufferPointer) == 0 {
                insertDirectiveWithoutSelection()
            } else {
                insertDirectiveWithSelection()
            }

            // MARK: Insert without a selection
            
            /// Insert without a selection
            func insertDirectiveWithoutSelection() {
                // *Repeat chorus* is an exception; it has no *start* and *end`* but it *is* an environment
                // - Give it additional *newlines* because the cursor will be moved
                if directive == .chorus {
                    directiveEnd += "\n\n"
                }

                // Move to start of the current line
                gtk_text_iter_set_line_offset(&insertIter, 0)

                let insert = "\(directiveStart)\(directiveEnd)\n"

                // Insert the directive
                gtk_text_buffer_insert(buffer.textBufferPointer, &insertIter, insert, -1)

                /// Move the cursor
                var cursorIter = cursorPosition

                if ChordPro.Directive.environmentDirectives.contains(directive) {
                    /// Move the cursor up two lines to be in between the directives
                    gtk_text_iter_backward_line(&cursorIter)
                    gtk_text_iter_backward_line(&cursorIter)
                } else {
                    /// Move it back just before the bracket
                    gtk_text_iter_backward_char(&cursorIter)
                    gtk_text_iter_backward_char(&cursorIter)
                }
                gtk_text_buffer_place_cursor(buffer.textBufferPointer, &cursorIter)
            }

            // MARK: Insert with a selection

            /// Insert with a selection
            func insertDirectiveWithSelection() {
                // *Repeat chorus* is an exception; it has no *start* and *end`* but it *is* and environment
                // - Add the selection as its label, so add a colon and give it some space 
                if directive == .chorus {
                    directiveStart += ": "
                }
                guard let selection = selectedText, var range = selectedRange else { return }
                let directive = "\(directiveStart)\(selection)\(directiveEnd)\n"
                // Delete everything that is selected
                gtk_text_buffer_delete(buffer.textBufferPointer, &range.start, &range.end)
                // Insert the directive
                gtk_text_buffer_insert(buffer.textBufferPointer, &range.start, directive, -1)
            }
        }
    }

    /// Append text and scroll to its position
    /// - Parameter text: The `String` to append
    private func appendTextAndScroll(_ text: String) {
        withUndoGroup {
            var range = bufferRange
            // Ensure we start on a new line
            if gtk_text_iter_starts_line(&range.end) == 0 {
                gtk_text_buffer_insert(buffer.textBufferPointer, &range.end, "\n", 1)
                gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &range.end)
            }
            // Blank line BEFORE
            gtk_text_buffer_insert(buffer.textBufferPointer, &range.end, "\n", 1)
            gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &range.end)
            // Insert text
            text.withCString { cString in
                gtk_text_buffer_insert(buffer.textBufferPointer, &range.end, cString, -1)
            }
            gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &range.end)
            // Blank line AFTER
            gtk_text_buffer_insert(buffer.textBufferPointer, &range.end, "\n\n", 2)
            gtk_text_buffer_get_end_iter(buffer.textBufferPointer, &range.end)
            // Move cursor to end
            gtk_text_buffer_place_cursor(buffer.textBufferPointer, &range.end)
            // Scroll to cursor
            scrollToCursor()
        }
    }
}

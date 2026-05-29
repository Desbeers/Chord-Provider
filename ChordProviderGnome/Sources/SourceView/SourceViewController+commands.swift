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
    case insertDirective(ChordPro.Directive)
    /// Replace all text
    case replaceAllText(String)
    /// Append text to the end of the source
    case appendText(String)
    /// Replace all text on a specific line in the editor
    case replaceLineText(String)
    /// Clear the current selection
    case clearSelection
    /// Schedule to update the song
    case updateSong
    /// Find
    case find(SourceViewController.SearchDirection)
    /// Hightlight
    case searchHighlight(Bool)
    /// Replace search
    case replaceSearchMatch(with: String)
        /// Replace all search
    case replaceAllSearchMatches(with: String) 
}

extension SourceViewController {

    // MARK: Command handler

    /// Handle a command for the editor
    /// - Parameter command: The ``SourceViewCommand``
    func handle(_ command: SourceViewCommand) {
        switch command {
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
        case .clearSelection:
            clearSelection()
        case .updateSong:
            scheduleSnapshot()
        case let .find(direction):
            find(direction: direction)
        case let .searchHighlight(highlight):
            searchHighlight(highlight)
        case let .replaceSearchMatch(replacement):
            replaceSearchMatch(with: replacement)
        case let .replaceAllSearchMatches(replacement):
            replaceAllSearchMatches(with: replacement)
        }
    }

    /// Clear any active selection in the text buffer
    private func clearSelection() {
        guard let buffer = buffer.textBufferPointer else { return }
        var insertIter = currentTextIter()
        // Collapse selection by placing cursor at insert position
        gtk_text_buffer_place_cursor(buffer, &insertIter)
    }

    /// Refocus the editor
    /// - Note: It will lose focus when the command is handled with a button
    private func refocusEditor() {
        gtk_widget_grab_focus(view.widgetPointer)
    }

    // MARK: Command functions

    /// Replace all the text in the editor
    /// - Parameter text: The replacement `String`
    private func replaceAllText(_ text: String) {
        guard let buffer = buffer.textBufferPointer else { return }
        // Close the *undo* group*
        defer {
            gtk_text_buffer_end_user_action(buffer)
        }
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
    }

    /// Replace text from the cursor position up to (but not including) the first newline
    /// - Parameter text: The replacement `String`
    private func replaceFromCursorToNewline(text: String) {
        guard let buffer = buffer.textBufferPointer else { return }
        // Close the *undo* group*
        defer {
            gtk_text_buffer_end_user_action(buffer)
        }
        // Make it one `undo` group
        gtk_text_buffer_begin_user_action(buffer)

        var start = currentTextIter()
        var end = currentTextIter()

        // Find end of line
        gtk_text_iter_forward_to_line_end(&end)

        // Delete everything up to the newline
        gtk_text_buffer_delete(buffer, &start, &end)

        // Insert replacement text at cursor
        text.withCString {
            gtk_text_buffer_insert_at_cursor(buffer, $0, -1)
        }
    }

    /// Insert a directive in the editor at the cursor position
    /// - Parameter directive: The `Directive` to add
    private func insertDirective(_ directive: ChordPro.Directive) {
        guard let buffer = buffer.textBufferPointer else { return }
        // Close the *undo* group*
        defer {
            gtk_text_buffer_end_user_action(buffer)
        }
        // Make it one `undo` group
        gtk_text_buffer_begin_user_action(buffer)

        var insertIter = currentTextIter()

        // Get the start and end values for the directive
        var directiveStart = directive.format.start
        var directiveEnd = directive.format.end

        if gtk_text_buffer_get_has_selection(buffer) == 0 {
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
            gtk_text_buffer_insert(buffer, &insertIter, insert, -1)

            /// Move the cursor
            var cursorIter = currentTextIter()

            if ChordPro.Directive.environmentDirectives.contains(directive) {
                /// Move the cursor up two lines to be in between the directives
                gtk_text_iter_backward_line(&cursorIter)
                gtk_text_iter_backward_line(&cursorIter)
            } else {
                /// Move it back just before the bracket
                gtk_text_iter_backward_char(&cursorIter)
                gtk_text_iter_backward_char(&cursorIter)
            }
            gtk_text_buffer_place_cursor(buffer, &cursorIter)
        }

        // MARK: Insert with a selection

        /// Insert with a selection
        func insertDirectiveWithSelection() {

            // *Repeat chorus* is an exception; it has no *start* and *end`* but it *is* and environment
            // - Add the selection as its label, so add a colon and give it some space 
            if directive == .chorus {
                directiveStart += ": "
            }

            var start = GtkTextIter()
            var end = GtkTextIter()
            gtk_text_buffer_get_selection_bounds(buffer, &start, &end)
            guard let selection = stringFromBuffer(start: &start, end: &end) else { return }
            let directive = "\(directiveStart)\(selection)\(directiveEnd)\n"
            // Delete everything that is selected
            gtk_text_buffer_delete(buffer, &start, &end)
            // Insert the directive
            start = currentTextIter()
            gtk_text_buffer_insert(buffer, &start, directive, -1)
        }
    }

    /// Append text and scroll to its position
    /// - Parameter text: The `String` to append
    private func appendTextAndScroll(_ text: String) {
        guard let buffer = buffer.textBufferPointer else { return }
        // Close the *undo* group*
        defer {
            gtk_text_buffer_end_user_action(buffer)
        }
        // Make it one `undo` group
        gtk_text_buffer_begin_user_action(buffer)

        var end = GtkTextIter()

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

        // Scroll to cursor
        scrollToCursor()
    }
}

extension SourceViewController {

    // MARK: Cursor movement

    /// Move the cursor to the first line of the song
    private func moveCursorToFirstLine() {
        guard let buffer = buffer.textBufferPointer else { return }
        var iter = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer, &iter)
        // Place cursor at start of line 0
        gtk_text_buffer_place_cursor(buffer, &iter)
        // Scroll to cursor
        if let insertMark = gtk_text_buffer_get_insert(buffer) {
            gtk_text_view_scroll_mark_onscreen(
                view.textViewPointer,
                insertMark
            )
        }
    }

    /// Scroll to the current cursor position
    func scrollToCursor() {
        guard let buffer = buffer.textBufferPointer else { return }
        if let insertMark = gtk_text_buffer_get_insert(buffer) {
            gtk_text_view_scroll_mark_onscreen(
                view.textViewPointer,
                insertMark
            )
        }
    }
}

extension SourceViewController {


    // MARK: Current line information

    /// Update the information about the current line
    func updateCurrentLine() {
        guard
            let bridge = view.fields["bridge"] as? Binding<SourceViewBridge>,
            let buffer = buffer.textBufferPointer
        else {
            return
        }
        var values = bridge.wrappedValue
        var iter = currentTextIter()
        let currentLineNumber = Int(gtk_text_iter_get_line(&iter) + 1)

        let totalLines = values.song.totalLines

        self.currentLine = values.songLines[safe: currentLineNumber - 1] ?? Song.Section.Line(sourceLineNumber: totalLines)

        isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        hasSelection = gtk_text_buffer_get_has_selection(buffer) != 0
        
        values.currentLine = currentLine
        values.isAtBeginningOfLine = isAtBeginningOfLine
        values.hasSelection = hasSelection
        bridge.wrappedValue = values
    }    
}

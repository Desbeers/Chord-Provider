//

//  Editor+Controller+snapshots.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor.Controller {

    // MARK: Snapshots

    /// Schedule a snapshot to update the text binding in the UI.
    /// - Note: This syncs the text buffer to the Swift callback.
    func scheduleSnapshot() {
        snapshotDebounce.schedule { [self] in
            if snippetsAvailable {
                // Don't flush the text or else the completion popup will flicker
                return
            }
            let markers = onTextChanged?(bufferText) ?? []
            // Clear all markers and add new ones if needed
            clearMarks()
            for marker in markers {
                addMark(
                    lineNumber: marker.lineNumber,
                    category: marker.category
                )
            }
            // Update the current line
            updateCurrentLine()
        }
    }

    // MARK: Current line information

    /// Update the information about the current line.
    func updateCurrentLine() {
        if !bridge.search.search.wrappedValue.isEmpty {
            setCurrentMatchIndex()
        }
        var bridgeValues = bridge.wrappedValue
        var iter = cursorPosition
        bridgeValues.currentLineNumber = Int(gtk_text_iter_get_line(&iter)) + 1
        bridgeValues.lineCount = Int(gtk_text_buffer_get_line_count(buffer.textBufferPointer))
        bridgeValues.isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        bridgeValues.hasSelection = gtk_text_buffer_get_has_selection(buffer.textBufferPointer) != 0
        bridge.wrappedValue = bridgeValues
        onLineChanged?()
    }
}

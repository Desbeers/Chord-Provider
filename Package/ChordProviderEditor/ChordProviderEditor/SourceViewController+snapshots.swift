//
//  SourceViewController+snapshots.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

// MARK: - Snapshots
//
// Sync the text buffer to the Swift callback.

extension SourceViewController {

    /// Schedule a snapshot to update the song render in the UI
    func scheduleSnapshot() {
        snapshotDebounce.schedule { [self] in
            if snippetsAvailable {
                // Don't flush the text or else the completion popup will flicker
                return
            }
            var markers: [SourceMark] = []
            if let onTextChanged {
                markers = onTextChanged(bufferText)
            }
            /// Clear all markers and add new ones if needed
            clearMarks()
            if !markers.isEmpty {
                for marker in markers {
                    addMark(
                        lineNumber: marker.lineNumber,
                        category: marker.category.rawValue
                    )
                }
            }
            /// Update the current line
            updateCurrentLine()
        }
    }
}

extension SourceViewController {

    // MARK: Current line information

    /// Update the information about the current line
    func updateCurrentLine() {
        guard let bridge = bridgeBinding else {
            return
        }
        if !bridge.search.search.wrappedValue.isEmpty {
            self.setCurrentMatchIndex()
        }
        var bridgeValues = bridge.wrappedValue
        var iter = self.cursorPosition
        bridgeValues.currentLineNumber = Int(gtk_text_iter_get_line(&iter)) + 1
        bridgeValues.totalLineNumbers = Int(gtk_text_buffer_get_line_count(self.buffer.textBufferPointer))
        bridgeValues.isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        bridgeValues.hasSelection = gtk_text_buffer_get_has_selection(self.buffer.textBufferPointer) != 0
        bridge.wrappedValue = bridgeValues
        if let onLineChanged = self.onLineChanged {
            onLineChanged()
        }
    }
}

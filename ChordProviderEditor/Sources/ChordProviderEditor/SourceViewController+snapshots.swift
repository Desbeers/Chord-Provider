//
//  SourceViewController+snapshots.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView
import ChordProviderCore

// MARK: - Snapshots
//
// Sync the text buffer to the Swift text binding

extension SourceViewController {

    /// Schedule a snapshot to update the song render in the UI
    func scheduleSnapshot() {
        snapshotDebounce.schedule { [self] in
            if snippetsAvailable {
                // Don't flush the text or else the completion popup will flicker
                return
            }
            guard
                let bridge = bridgeBinding
            else { return }
            var values = bridge.wrappedValue
            /// Get all the text from the buffer
            let text = bufferText
            /// Clear the log for a new parsing
            LogUtils.shared.clearLog()
            values.song.content = text
            values.song = ChordProParser.parse(content: text, song: values.song, settings: values.coreSettings)
            /// Clear all markers and add new ones if needed
            clearMarks()
            if values.coreSettings.showWarnings {
                /// Get all lines, removing anything added by the parser
                let lines = values.song.allLines.filter { $0.sourceLineNumber > 0 }
                values.songLines = lines
                for line in lines.filter({ $0.warnings != nil }) {
                    let level = line.warnings?.compactMap(\.level).min() ?? .info
                    addMark(
                        lineNumber: line.sourceLineNumber,
                        category: level.rawValue
                    )
                }
            }
            bridge.wrappedValue = values
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
        var values = bridge.wrappedValue
        var iter = cursorPosition
        let currentLineNumber = Int(gtk_text_iter_get_line(&iter)) + 1

        let totalLines = values.song.totalLines

        let currentLine = values.songLines[safe: currentLineNumber - 1] ?? Song.Section.Line(sourceLineNumber: totalLines)

        isAtBeginningOfLine = gtk_text_iter_get_line_offset(&iter) == 0
        hasSelection = gtk_text_buffer_get_has_selection(buffer.textBufferPointer) != 0

        values.currentLine = currentLine
        values.isAtBeginningOfLine = isAtBeginningOfLine
        values.hasSelection = hasSelection
        bridge.wrappedValue = values
    }
}

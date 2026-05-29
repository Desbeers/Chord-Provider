//
//  SourceViewController+snapshots.swift
//  GtkSourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView
import ChordProviderCore

// MARK: - Snapshots
//
// Sync the text buffer to the Swift text binding

extension SourceViewController {

    func snapshotText() -> String? {
        guard let buffer = buffer.textBufferPointer else { return "" }
        var start = GtkTextIter()
        var end = GtkTextIter()
        gtk_text_buffer_get_start_iter(buffer, &start)
        gtk_text_buffer_get_end_iter(buffer, &end)
        return stringFromBuffer(start: &start, end: &end)
    }

    func scheduleSnapshot() {
        snapshotDebounce.schedule { [self] in
            resetSearchPosition()
            if snippetsAvailable {
                // Don't flush the text or else the completion popup will flicker
                return
            }
            guard
                let buffer = view.content["buffer"]?.first,
                let bridge = view.fields["bridge"] as? Binding<SourceViewBridge>,
                let text = snapshotText()
            else {
                return
            }

            gtk_text_buffer_get_start_iter(
                buffer.textBufferPointer,
                &self.currentSearchIter
            )
            /// Clear the log for a new parsing
            LogUtils.shared.clearLog()
            /// Get the values of the bridge binding
            var values = bridge.wrappedValue
            values.song.content = text
            values.song = ChordProParser.parse(song: values.song, settings: values.coreSettings)
            /// Clear all markers and add new ones if needed
            clearMarks()
            if values.coreSettings.showWarnings {
                /// Get all lines, removing anything added by the parser
                let lines = values.song.allLines.filter {$0.sourceLineNumber > 0}
                values.songLines = lines
                for line in lines.filter({ $0.warnings != nil }) {
                    let level = line.warnings?.compactMap(\.level).sorted().last ?? .info
                    addMark(
                        buffer: buffer,
                        lineNumber: line.sourceLineNumber,
                        category: level.rawValue
                    )
                }
            }
            /// Update the bridge
            bridge.wrappedValue = values
            /// Update the current line
            updateCurrentLine()
        }
    }
}

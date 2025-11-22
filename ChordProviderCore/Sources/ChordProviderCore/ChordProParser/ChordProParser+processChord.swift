//
//  ChordProParser+processChord.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a chord

    /// Process a chord
    /// - Parameters:
    ///   - chord: The `chord` as String
    ///   - line: The current line of the section
    ///   - song: The whole ``Song``
    /// - Returns: The processed `chord` as String
    static func processChord(
        chord: String,
        line: inout Song.Section.Line,
        song: inout Song
    ) -> ChordDefinition {
        /// First, check if the chord is just text
        if chord.starts(with: "*") {
            let text = String(chord.dropFirst())
            return ChordDefinition(text: text, instrument: song.settings.instrument)
        } else {
            /// Check if this chord is already parsed
            if  let match = song.chords.last(where: { $0.name == chord }) {
                if match.status == .unknownChord {
                    /// Add a warning that the chord is unknown
                    line.addWarning("Unknown chord: <b>(chord)</b>", level: .error)
                }
                return match
            }
            /// Try to find it in the database
            if var databaseChord = ChordDefinition(name: chord, instrument: song.settings.instrument) {
                if song.settings.transpose != 0 {
                    databaseChord.transpose(transpose: song.settings.transpose, scale: song.metadata.key?.root ?? .c)
                    /// Keep the original name
                    databaseChord.name = chord
                }
                /// Mirror if needed
                if song.settings.diagram.mirror {
                    databaseChord.mirrorChordDiagram()
                }
                song.chords.append(databaseChord)
                return databaseChord
            }
            let unknownChord = ChordDefinition(unknown: chord, instrument: song.settings.instrument)
            /// Add a warning that the chord is unknown
            line.addWarning("Unknown chord: <b>\(chord)</b>", level: .error)
            /// Return the unknown chord
            return unknownChord
        }
    }
}

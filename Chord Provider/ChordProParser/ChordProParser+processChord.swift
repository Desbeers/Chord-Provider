//
//  ChordProParser+processChord.swift
//  Chord Provider
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
    ///   - ignoreUnknown: Bool to ignore an unknown chord so it will not be added to the chord list
    /// - Returns: The processed `chord` as String
    static func processChord(
        chord: String,
        line: inout Song.Section.Line,
        song: inout Song,
        ignoreUnknown: Bool = false
    ) -> ChordDefinition {
        /// Check if this chord is already parsed
        if  let match = song.chords.last(where: { $0.name == chord }) {
            if match.status == .unknownChord {
                /// Add a warning that the chord is unknown
                line.addWarning("Unknown chord: **\(chord)**")
            }
            return match
        }
        /// Try to find it in the database
        if var databaseChord = ChordDefinition(name: chord, instrument: song.settings.display.instrument) {
            if song.metadata.transpose != 0 {
                databaseChord.transpose(transpose: song.metadata.transpose, scale: song.metadata.key?.root ?? .c)
                /// Keep the original name
                databaseChord.name = chord
            }
            song.chords.append(databaseChord)
            return databaseChord
        }
        let unknownChord = ChordDefinition(unknown: chord, instrument: song.settings.display.instrument)
        if !ignoreUnknown {
            song.chords.append(unknownChord)
        }
        /// Add a warning that the chord is unknown
        line.addWarning("Unknown chord: **\(chord)**")
        /// Return the unknown chord
        return unknownChord
    }
}

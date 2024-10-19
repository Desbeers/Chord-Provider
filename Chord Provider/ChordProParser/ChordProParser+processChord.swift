//
//  ChordProParser+processChord.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension ChordProParser {

    // MARK: Process a chord

    /// Process a chord
    /// - Parameters:
    ///   - chord: The `chord` as String
    ///   - song: The `Song`
    ///   - ignoreUnknown: Bool to ignore an unknown chord so it will not be added to the chord list
    /// - Returns: The processed `chord` as String
    static func processChord(chord: String, song: inout Song, ignoreUnknown: Bool = false) -> ChordDefinition {
        /// Check if this chord is already parsed
        if  let match = song.chords.last(where: { $0.name == chord }) {
            return match
        }
        /// Try to find it in the database
        if var databaseChord = ChordDefinition(name: chord, instrument: song.settings.song.instrument) {
            if song.metaData.transpose != 0 {
                databaseChord.transpose(transpose: song.metaData.transpose, scale: song.metaData.key?.root ?? .c)
                /// Keep the original name
                databaseChord.name = chord
            }
            song.chords.append(databaseChord)
            return databaseChord
        }
        let unknownChord = ChordDefinition(unknown: chord, instrument: song.settings.song.instrument)
        if !ignoreUnknown {
            song.chords.append(unknownChord)
        }
        return unknownChord
    }
}

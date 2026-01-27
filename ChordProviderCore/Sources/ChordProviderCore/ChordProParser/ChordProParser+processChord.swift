//
//  ChordProParser+processChord.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation
import RegexBuilder

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
            return ChordDefinition(text: text, kind: .textChord, instrument: song.settings.instrument)
        } else {
            /// Check if this chord is already parsed
            if let match = song.chords
                .last(where: { $0.transposedName == "\(chord)-\(song.transposing)" })
            {
                return match
            }
            if var databaseChord = ChordDefinition(name: chord, instrument: song.settings.instrument) {
                if song.transposing != 0 {
                    databaseChord.transpose(transpose: song.transposing, scale: song.metadata.key?.root ?? .c)
                }
                /// Add it to the chords list
                song.chords.append(databaseChord)
                /// Set chord as key if not set manually
                if song.metadata.key == nil {
                    song.metadata.key = song.chords.first
                }
                return databaseChord
            }
            var unknownChord = ChordDefinition(
                text: chord,
                kind: song.transposing == 0 ? .unknownChord : .transposedUnknownChord,
                instrument: song.settings.instrument
            )
            //unknownChord.kind = song.transposing == 0 ? .unknownChord : .transposedUnknownChord
            /// Add a warning that the chord is unknown
            line.addWarning("Unknown chord: <b>\(chord)</b>", level: .error)
            /// Return the unknown chord
            return unknownChord
        }
    }
}

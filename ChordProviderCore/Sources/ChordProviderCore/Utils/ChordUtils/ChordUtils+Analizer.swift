//
//  ChordUtils+Analizer.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordUtils {

    /// Analize a chord
    ///
    /// - Find the root, quality and optional slash of a chord
    /// - Try to validate a chord
    enum Analizer {

        /// Find the root, quality and optional bass of a named chord
        /// - Parameter chord: The name of the chord as `String`
        /// - Returns: The root, quality and optional slash
        static func findChordElements(chord: String) -> (root: Chord.Root?, quality: Chord.Quality?, slash: Chord.Root?) {
            var root: Chord.Root?
            var quality: Chord.Quality?
            var slash: Chord.Root?
            if let match = chord.wholeMatch(of: ChordPro.RegexDefinitions.chordString) {
                root = match.1
                if let qualityMatch = match.2 {
                    quality = qualityMatch
                } else {
                    quality = Chord.Quality.major
                }
                slash = match.3
            }
            return (root, quality, slash)
        }

        /// Try to validate a ``ChordDefinition``
        /// - Parameter chord: The ``ChordDefinition``
        /// - Returns: The ``ChordDefinition/Status`` of the chord definition
        static func validateChord(chord: ChordDefinition) -> ChordDefinition.Status {
            if chord.quality == .unknown {
                return .wrongNotes
            }
            /// Get the lowest note of the chord
            guard let baseNote = chord.components.filter({ $0.note != .none }) .sorted(using: KeyPathComparator(\.midi)).first?.note else {
                return .unknownChord
            }
            /// Get all chord notes
            let notes = chord.components.filter { $0.note != .none } .uniqued(by: \.note).map(\.note)
            /// Get all note combinations
            let combinations = chord.noteCombinations
            /// Check slash note
            if let slash = chord.slash {
                if ChordUtils.noteToValue(note: baseNote) != ChordUtils.noteToValue(note: slash) {
                    return .wrongBassNote
                }
                /// Check root note
            } else if baseNote != chord.root {
                return .wrongRootNote
            }
            /// Check fingers
            for index in chord.frets.enumerated() {
                /// Check that open frets have no finger defined
                if chord.frets[index.offset] == -1 && chord.fingers[index.offset] != 0 {
                    return .wrongFingers
                }
                /// Check that a fretted note has a finger defined
                if chord.frets[index.offset] > 0 && chord.fingers[index.offset] == 0 {
                    return .missingFingers
                }
            }
            /// Check notes
            for combination in combinations {
                if notes.contains(combination.map(\.note)) {
                    return .correct
                }
            }
            /// No match found
            return .wrongNotes
        }

        /// Get all possible note combinations for a ``ChordDefinition``
        /// - Returns: An array with ``Chord/Note`` arrays
        static func noteCombinations(chord: ChordDefinition) -> [[Chord.Note]] {
            /// All the possible note combinations
            var allNoteCombinations: [[Chord.Note]] = []

            /// Get the root note value
            let rootValue = ChordUtils.noteToValue(note: chord.root)
            /// Get all notes
            let notes = chord.quality.intervals.intervals.map(\.semitones).map { tone in
                ChordUtils.valueToNote(value: tone + rootValue, scale: chord.root)
            }
            /// Get a list of optional notes that can be omitted
            let optionals = chord.quality.intervals.optional.map(\.semitones).map { tone in
                ChordUtils.valueToNote(value: tone + rootValue, scale: chord.root)
            }.combinationsWithoutRepetition
            /// Make a list with all optionals
            let optionalList = optionals.last ?? []
            /// Make all combinations
            for optional in optionals {
                var components = notes.filter { !optional.contains($0) }
                /// Add the optional slash bass
                if let slash = chord.slash, !components.values.contains(slash.value) {
                    components.insert(slash, at: 0)
                }
                allNoteCombinations.append(components.map { Chord.Note(note: $0, required: !optionalList.contains($0)) })
            }
            /// Return the result
            return allNoteCombinations
        }
    }
}

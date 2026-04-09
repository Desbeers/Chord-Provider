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
        static func findChordElements(
            chord: String
        ) -> (root: Chord.Root?, quality: Chord.Quality?, slash: Chord.Root?) {
            var root: Chord.Root?
            var quality: Chord.Quality?
            var slash: Chord.Root?
            if let match = chord.wholeMatch(of: RegexDefinitions.chordString) {
                root = match.1
                if let qualityMatch = match.2 {
                    quality = qualityMatch == .none ? nil : qualityMatch
                } else {
                    quality = .major
                }
                slash = match.3
            }
            return (root, quality, slash)
        }

        /// Try to validate a ``ChordDefinition``
        /// - Parameter chord: The ``ChordDefinition``
        /// - Returns: The ``ChordDefinition/Status`` of the chord definition
        static func validateChord(chord: ChordDefinition) -> [ChordDefinition.Status] {
            var result: Set<ChordDefinition.Status> = []
            if chord.quality == .none {
                result.insert(.unknownChord(chord: chord.plain))
                return Array(result)
            }
            /// Check amount of frets
            if chord.frets.count < chord.instrument.strings.count {
                result.insert(.notEnoughFrets)
            }
            if chord.frets.count > chord.instrument.strings.count {
                result.insert(.tooManyFrets)
            }
            /// Check amount of fingers
            if chord.fingers.count < chord.instrument.strings.count {
                result.insert(.notEnoughFingers)
            }
            if chord.fingers.count > chord.instrument.strings.count {
                result.insert(.tooManyFingers)
            }
            /// If we have already a warning, we stop validating
            /// - Note: Without correct frets and fingers we will get a fatal `out of range` error
            if !Set(result).isDisjoint(with: ChordDefinition.Status.errorStatus) {
                return Array(result).sorted()
            }
            /// Get the lowest note of the chord
            guard let baseNote = chord.components.filter({ $0.note != .none }) .sorted(using: KeyPathComparator(\.midi)).first?.note else {
                /// The definition has no notes att all
                result.insert(.noNotes)
                return Array(result)
            }
            /// Get all chord notes
            let notes = chord.components.filter { $0.note != .none } .uniqued(by: \.note).map(\.note)
            /// Get all note combinations
            let combinations = chord.noteCombinations
            /// Check slash note
            if let slash = chord.slash {
                if ChordUtils.noteToValue(note: baseNote) != ChordUtils.noteToValue(note: slash) {
                    result.insert(.wrongBassNote(bass: slash.display))
                }
                /// Check root note
            } else if baseNote != chord.root {
                result.insert(.wrongRootNote(root: chord.root.display))
            }
            /// Check finger positions
            for index in chord.frets.enumerated() {
                /// Check that muted frets have no finger defined
                if chord.frets[index.offset] == -1 && chord.fingers[safe: index.offset] != 0 {
                    result.insert(.wrongMutedFingers)
                }
                /// Check that open frets have no finger defined
                if chord.frets[index.offset] == 0 && chord.fingers[safe: index.offset] != 0 {
                    result.insert(.wrongOpenFingers)
                }
                /// Check that a fretted note has a finger defined
                if chord.frets[index.offset] > 0 && chord.fingers[safe: index.offset] == 0 {
                    result.insert(.missingFingers)
                }
            }
            /// Check notes

            /// The actual notes of the chord
            let played = notes.uniqued(by: \.id)
            /// The notes required for the chord, including optional notes
            let allowedNotes = combinations.first?.map(\.note) ?? []
            let wrongNotes   = played.filter { !allowedNotes.contains($0) }
            if !wrongNotes.isEmpty {
                let notes = wrongNotes.map(\.description).joined(separator: ", ")
                result.insert(.wrongNotes(notes: notes))
            }
            /// The notes required for the chord, excluding optional notes
            let requiredNotes = combinations.last?.map(\.note) ?? []
            let missingNotes = requiredNotes.filter { !played.contains($0) }
            if !missingNotes.isEmpty {
                let notes = missingNotes.map(\.description).joined(separator: ", ")
                result.insert(.missingRequiredNotes(notes: notes))
            }

            /// Return the result
            return Array(result).sorted()
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

//
//  Chord+Analizer.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Chord {

    /// Analize a chord
    enum Analizer {

        /// Find the root, quality and optional bass of a named chord
        /// - Parameter chord: The name of the chord as `String`
        /// - Returns: The root, quality and optional slash
        static func findChordElements(chord: String) -> (root: Chord.Root?, quality: Chord.Quality?, slash: Chord.Root?) {
            var root: Chord.Root?
            var quality: Chord.Quality?
            var slash: Chord.Root?
            if let match = chord.wholeMatch(of: RegexDefinitions.chordString) {
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
        /// - Returns: The ``Chord/Status`` of the chord definition
        static func validateChord(chord: ChordDefinition) -> Chord.Status {
            if chord.quality == .unknown {
                return .wrongNotes
            }
            /// Get the lowest note of the chord
            guard let baseNote = chord.components.filter({ $0.note != .none }) .sorted(using: KeyPathComparator(\.midi)).first?.note else {
                return .unknownChord
            }
            /// Get all chord notes
            let notes = chord.components.filter { $0.note != .none } .uniqued(by: \.note).map(\.note)
            /// Get all component combinations
            let components = ChordUtils.getChordComponents(chord: chord)
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
            /// Check if we have a match
            for component in components where component.values == notes.values {
                return .correct
            }
            /// No match found
            return .wrongNotes
        }
    }
}

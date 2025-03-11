//
//  Analizer.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Analize a chord
enum Analizer {


    /// Find the root, quality and optional bass of a named chord
    /// - Parameter chord: The name of the chord
    /// - Returns: The root and quality
    static func findChordElements(chord: String) -> (root: Chord.Root?, quality: Chord.Quality?, bass: Chord.Root?) {
        var root: Chord.Root?
        var quality: Chord.Quality?
        var bass: Chord.Root?
        if let match = chord.wholeMatch(of: RegexDefinitions.chordName) {
            root = match.1
            if let qualityMatch = match.2 {
                quality = qualityMatch
            } else {
                quality = Chord.Quality.major
            }
            bass = match.3
        }
        return (root, quality, bass)
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
        let components = Utils.getChordComponents(chord: chord)
        /// Check bass note
        if let bass = chord.bass {
            if Utils.noteToValue(note: baseNote) != Utils.noteToValue(note: bass) {
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
        for component in components where component.notesToValues == notes.notesToValues {
            return .correct
        }
        /// No match found
        return .wrongNotes
    }
}

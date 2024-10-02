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
    // swiftlint:disable:next large_tuple
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
    /// - Returns: The ``ChordValidation``
    static func validateChord(chord: ChordDefinition) -> Chord.Status {
        if chord.quality == .unknown {
            return .wrongNotes
        }
        var validation: Chord.Status = .correct
        var notes = chord.components.filter { $0.note != .none } .uniqued(by: \.note).map(\.note)
        let components = Utils.getChordComponents(chord: chord, addBase: false)
        for component in components {
            /// Check bass note
            if let bass = chord.bass {
                if notes.first != bass {
                    return .wrongBassNote
                } else if !component.contains(bass) {
                    notes.removeAll { $0 == bass }
                }
            }
            /// Check root note
            else if notes.first != chord.root {
                validation = .wrongRootNote
            }
            /// Check fingers
            else {
                for index in chord.frets.enumerated() {
                    if chord.frets[index.offset] == -1 && chord.fingers[index.offset] != 0 {
                        return .wrongFingers
                    }
                }
            }
            if component.sorted() == notes.sorted() {
                return validation
            }
        }
        return .wrongNotes
    }
}

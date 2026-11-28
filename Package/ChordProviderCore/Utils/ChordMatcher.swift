//
//  ChordMatcher.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

/// Find the most basic chord for held MIDI notes
public struct ChordMatcher {

    /// Chord definitions grouped by their pitch class mask
    private let chordsByMask: [Int: [ChordDefinition]]
    /// Init the matcher
    public init(chords: [ChordDefinition]) {
        chordsByMask = Dictionary(grouping: chords) { definition in
            definition.pitchClasses.mask
        }
    }

    /// The chord with the same note names and bass note, at the lowest base fret
    public func bestMatch(for notes: [Int]) -> Match {
        guard !notes.isEmpty else {
            return Match()
        }
        let chord = (chordsByMask[notes.pitchClasses.mask] ?? [])
            .filter { $0.bassPitchClass == notes.bassPitchClass }
            .min { $0.baseFret.rawValue < $1.baseFret.rawValue }
        return Match(
            chord: chord,
            notes: notes.map { midi in
                Chord.Note(
                    note: ChordUtils.valueToNote(value: midi, scale: chord?.root ?? .e),
                    octave: midi / 12 - 1
                )
            }
        )
    }
}

extension ChordMatcher {

    /// A chord found for the held notes
    public struct Match: Sendable {

        /// Init the ``Match``
        /// - Parameters:
        ///   - chord: The matching chord, if any
        ///   - notes: The notes that are not held
        public init(chord: ChordDefinition? = nil, notes: [Chord.Note] = []) {
            self.chord = chord
            self.notes = notes
        }

        /// The matching chord
        public let chord: ChordDefinition?
        /// The notes that are played
        public let notes: [Chord.Note]
    }
}

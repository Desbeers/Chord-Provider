//
//  Chord.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// Bits and pieces that makes a ``ChordDefinition``
enum Chord {

    /// The grouping of chords
    enum Group {
        /// Major chords
        case major
        /// Minor chords
        case minor
        /// Diminished chords
        case diminished
        /// Augmented chords
        case augmented
        /// Suspended chords
        case suspended
        /// All other chords
        case other
    }

    /// The accidental of a root
    enum Accidental {
        /// Natural accidental
        case natural
        /// Sharp accidental
        case sharp
        /// Flat accidental
        case flat
    }
}

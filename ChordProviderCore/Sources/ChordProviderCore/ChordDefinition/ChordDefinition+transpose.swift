//
//  ChordDefinition+transpose.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// Transpose a ``ChordDefinition``
    /// - Parameters:
    ///   - transpose: The transpose value
    ///   - scale: The scale of the chord
    mutating func transpose(transpose: Int, scale: Chord.Root, chords: [ChordDefinition]) {
        /// Keep the current status
        let kind = self.kind
        /// Get the new name by adding the transpose value, it will keep the original chord name
        /// - Note: For transposing custom chords
        let newName = self.name + "-\(transpose)"
        // /// Get the chords for the instrument
        // let chords = ChordUtils.getAllChordsForInstrument(instrument: instrument.type)
        /// Transpose the root
        let root = ChordUtils.transposeNote(note: self.root, transpose: transpose, scale: scale)
        /// Find it in the database
        if let chord = chords
            .matching(root: root)
            .matching(quality: self.quality)
            .matching(slash: self.slash)
            .first {
            self = chord
            self.kind = kind == .customChord ? .customTransposedChord : .transposedChord
            /// Save the transpose value
            self.transposed = transpose
            /// Set the transposed name
            self.transposedName = newName
        } else {
            self.root = root
            self.kind = .transposedUnknownChord
            self.status = .unknownChord
        }
    }
}

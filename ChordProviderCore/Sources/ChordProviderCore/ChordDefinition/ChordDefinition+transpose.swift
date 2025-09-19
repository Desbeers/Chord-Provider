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
    mutating func transpose(transpose: Int, scale: Chord.Root) {
        if self.status == .customChord {
            self.status = .customTransposedChord
        } else {
            /// Get the chords for the instrument
            let chords = ChordUtils.getAllChordsForInstrument(instrument: instrument)
            let root = ChordUtils.transposeNote(note: self.root, transpose: transpose, scale: scale)
            if let chord = chords.matching(root: root).matching(quality: self.quality).matching(slash: self.slash).first {
                self = chord
                self.name = self.getName
                self.status = .transposedChord
            } else {
                self.root = root
                self.status = .transposedUnknownChord
            }
        }
    }
}

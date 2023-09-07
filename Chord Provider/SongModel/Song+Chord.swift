//
//  Song+Chord.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension Song {

    /// A chord in the ``Song``
    struct Chord: Identifiable {
        /// The unique ID of the chord
        var id = UUID()
        /// The name of the chord
        var name: String
        /// The ChordPosition definition
        var chordPosition: ChordPosition
        /// The status of the chord
        var status: Status
        /// Display name for the chord
        var display: String {
            switch status {
            case .standard, .transposed:
                return chordPosition.key.display.symbol + chordPosition.suffix.display.symbolized
            case .custom, .customTransposed:
                /// Try to find it in the SwiftyChords database
                let chord = findRootAndQuality(chord: name)
                if let root = chord.root, let quality = chord.quality {
                    return "\(root.display.symbol)\(quality.display.symbolized)*"
                }
                return "\(name)*"
            case .unknown:
                return "\(name)*"
            }
        }

        /// The chord postions are different if this is a custom chord. So return the custom chord or the default standard chord positions.
        /// - Returns: all chord postions for this chord
        func getChordPostions() -> [ChordPosition] {
            var chordPositions = [ChordPosition]()
            switch status {
            case .standard, .transposed:
                chordPositions = Chords.guitar.matching(key: chordPosition.key).matching(suffix: chordPosition.suffix)
            case .custom, .customTransposed:
                chordPositions.append(chordPosition)
            case .unknown:
                break
            }
            return chordPositions
        }
    }
}

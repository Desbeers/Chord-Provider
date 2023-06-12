//
//  Song+Chord.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords
import SwiftlyChordUtilities

extension Song {

    /// A chord in the ``Song``
    struct Chord: Identifiable {
        /// The unique ID of the chord
        var id = UUID()
        /// The name of the chord
        var name: String
        /// The ChordPosition defenition
        var chordPosition: ChordPosition
        /// Bool if the chord is custom or from the SwiftyChords database
        var isCustom: Bool
        /// Display name for the chord
        var display: String {
            if isCustom {
                /// Try to find it in the SwiftyChords database
                let chord = findRootAndQuality(chord: name)
                if let root = chord.root, let quality = chord.quality {
                    return "\(root.display.symbol)\(quality.display.symbolized)*"
                }
                return "\(name)*"
            } else {
                var text = chordPosition.key.display.symbol
                switch chordPosition.suffix {
                case .major:
                    break
                default:
                    text += chordPosition.suffix.display.symbolized
                }
                return text
            }
        }

        /// The chord postions are different if this is a custom chord. So return the custom chord or the default standard chord positions.
        /// - Returns: all chord postions for this chord
        func getChordPostions() -> [ChordPosition] {
            var chordPositions = [ChordPosition]()
            if isCustom {
                chordPositions.append(chordPosition)
            } else {
                chordPositions = SwiftyChords.Chords.guitar.matching(key: chordPosition.key).matching(suffix: chordPosition.suffix)
            }
            return chordPositions
        }
    }
}

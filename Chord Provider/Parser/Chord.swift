//
//  Chord.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation
import SwiftyChords

extension Song {
    
    /// The chords of the ``Song``
    struct Chord: Identifiable {
        var id = UUID()
        var name: String
        var chordPosition: ChordPosition
        var isCustom: Bool
        
        /// Display name for the chord
        var display: String {
            if isCustom {
                return name
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

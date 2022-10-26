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
    }
}

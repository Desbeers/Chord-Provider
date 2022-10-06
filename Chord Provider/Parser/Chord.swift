//
//  Chords.swift
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
        var key: SwiftyChords.Chords.Key
        var suffix: SwiftyChords.Chords.Suffix
        var define: String
        var basefret: Int {
            return Int(define.prefix(1)) ?? 1
        }
    }
}

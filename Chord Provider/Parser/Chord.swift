//
//  Chords.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation
import GuitarChords

extension Song {
    
    /// The chords of the ``Song``
    struct Chord: Identifiable {
        var id = UUID()
        var name: String
        var key: GuitarChords.Key
        var suffix: GuitarChords.Suffix
        var define: String
        var basefret: Int {
            return Int(define.prefix(1)) ?? 1
        }
    }
}

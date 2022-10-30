//
//  Chord.swift
//  Chords Database
//
//  Created by Nick Berendsen on 30/10/2022.
//

import Foundation
import SwiftyChords

struct Chord: Equatable {
    public var id: UUID
    public var frets: [Int]
    public var fingers: [Int]
    public var baseFret: Int
    public var barres: Int
    public var capo: Bool?
    public var midi: [Int] {
        return MidiNotes.values(values: self)
    }
    public var key: Chords.Key
    public var suffix: Chords.Suffix
}

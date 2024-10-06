//
//  ChordsDatabase.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure of the chords database
struct ChordsDatabase: Codable {
    /// The ``Instrument`` of the database
    let instrument: Instrument
    /// The chord definitions in **ChordPro** format
    let definitions: [String]
}

//
//  Database.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure of the chord database
struct Database: Codable {
    /// The ``Instrument`` of the database
    let instrument: Instrument
    /// The chord definitions in **ChordPro** format
    let definitions: [String]
}

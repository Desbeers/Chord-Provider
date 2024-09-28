//
//  Database.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure of the chord database
public struct Database: Codable {
    /// Init the database
    /// - Parameters:
    ///   - instrument: The ``Instrument`` of the database
    ///   - definitions: The chord definitions in **ChordPro** format
    public init(instrument: Instrument, definitions: [String]) {
        self.instrument = instrument
        self.definitions = definitions
    }
    /// The ``Instrument`` of the database
    public let instrument: Instrument
    /// The chord definitions in **ChordPro** format
    public let definitions: [String]
}

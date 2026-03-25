//
//  ChordsDatabase.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Structure for a database with with definitions for an instrument
public struct ChordsDatabase: Codable, Sendable, Equatable {

    /// Init a Chords Database with all known values
    /// - Parameters:
    ///   - instrument: The ``Instrument`` for the definitions
    ///   - definitions: The ``ChordDefinitions``
    public init(instrument: Instrument, definitions: [ChordDefinition]) {
        self.instrument = instrument
        self.definitions = definitions
    }

    /// The instrument for the definitions
    public var instrument: Instrument
    /// The chord definitions
    public var definitions: [ChordDefinition] = []
    /// Coding Keys
    /// - Note: Used for JSON import/export
    enum CodingKeys: String, CodingKey {
        /// Only import/export the instrument
        case instrument
    }
}

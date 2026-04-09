//
//  ChordsDatabase.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Structure for a database with with definitions for an instrument
public struct ChordsDatabase: Codable, Sendable, Equatable {

    /// Init an empty Chords Database, defaults to guitar as instrument
    public init() {
        let instrument = Instrument[.guitar]
        self.instrument = instrument
        self.definitions = []
    }

    /// The instrument for the definitions
    public var instrument: Instrument
    /// The chord definitions
    public var definitions: [ChordDefinition] = []
    /// The optional errors
    public var errors: [ChordProviderError] = []
    /// Coding Keys
    /// - Note: Used for JSON import/export
    enum CodingKeys: String, CodingKey {
        /// Only import/export the instrument
        case instrument
    }
}

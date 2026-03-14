//
//  Chord+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct ChordsDatabase: Codable, Sendable, Equatable {

    /// Init an empty database
    public init() {
        let instrument = Chord.Instrument(
            type: .guitar, 
            description: Chord.InstrumentType.guitar.label,
            tuning: ["E2", "A2", "D3", "G3", "B3", "E4"]
        )
        self.instrument = instrument
        self.definitions = []
    }

    /// Init the database with a standard instrument from the resource bundle
    public init(bundle: Chord.InstrumentType) {
        let database = Bundle.module.decode(ChordPro.Instrument.self, from: bundle.database)
        var definitions: [ChordDefinition] = []

        let instrument = Chord.Instrument(
            type: Chord.InstrumentType(rawValue: database.instrument.type) ?? .guitar,
            description: database.instrument.description,
            tuning: database.tuning
        )

        /// Get all chord definitions
        for chord in database.chords {
            if let result = ChordDefinition(chord: chord, instrument: instrument) {
                definitions.append(result)
            }
        }
        definitions.sort(
            using: [
                KeyPathComparator(\.baseFret), KeyPathComparator(\.frets.description)
            ]
        )
        self.instrument = instrument
        self.definitions = definitions
    }

    public var instrument: Chord.Instrument

    public var definitions: [ChordDefinition] = []

        /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the instrument
        case instrument
    }
}

extension ChordsDatabase {

    /// The instruments we know about
    public enum BuildIn: String, CaseIterable, Codable, Sendable {
        /// Guitar Standard E tuning
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele Standard G tuning
        case ukulele

        case testing

        /// The databases for the instruments in the `Resources` folder
        public var database: String {
            switch self {
            case .guitar:
                "ChordDefinitions/GuitarStandardETuning"
            case .guitalele:
                "ChordDefinitions/GuitaleleStandardATuning"
            case .ukulele:
                "ChordDefinitions/UkuleleStandardGTuning"
            case .testing:
                "ChordDefinitions/Testing"
            }
        }
    }
}
//
//  Chord+InstrumentType.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The instruments we know about
    public enum InstrumentType: String, CaseIterable, Codable, Sendable {
        /// Guitar Standard E tuning
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele Standard G tuning
        case ukulele
        /// Testing
        case testing
    }
}

extension Chord.InstrumentType {

    public static func instruments(debug: Bool) -> [Chord.InstrumentType] {
        var instruments: [Chord.InstrumentType] = [.guitar, .guitalele, .ukulele]
        if debug {
            instruments.append(.testing)
        }
        return instruments
    }
}

extension Chord.InstrumentType: Identifiable, CustomStringConvertible {

    /// Identifiable protocol
    public var id: Self { self }
    /// CustomStringConvertible protocol
    public var description: String {
        rawValue.capitalized
    }
}

extension Chord.InstrumentType {

    /// The label of the instrument
    public var label: String {
        switch self {
        case .guitar:
            "Guitar, 6 strings, standard tuning"
        case .guitalele:
            "Guitalele, 6 strings, standard tuning"
        case .ukulele:
            "Ukulele, 4 strings, standard tuning"
        case .testing:
            "Testing, 3 strings, stupid tuning"
        }
    }
}

extension Chord.InstrumentType {

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

//
//  Chord+InstrumentType.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    public static let buildIn: [Chord.Instrument] = [
        Instrument(
            type: .guitar,
            label: "Standard Tuning",
            tuning: ["E2", "A2", "D3", "G3", "B3", "E4"],
            bundle: "ChordDefinitions/GuitarStandardETuning"
            ),
        Instrument(
            type: .guitalele,
            label: "Standard Tuning",
            tuning: ["A2", "D3", "G3", "C4", "E4", "A4"],
            bundle: "ChordDefinitions/GuitaleleStandardATuning"
            ),
        Instrument(
            type: .ukulele,
            label: "Standard Tuning",
            tuning: ["G4", "C4", "E4", "A4"],
            bundle: "ChordDefinitions/UkuleleStandardGTuning"
            )
    ]

    /// The instruments we know about
    public enum InstrumentType: String, CaseIterable, Codable, Sendable {
        /// Guitar
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele
        case ukulele
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

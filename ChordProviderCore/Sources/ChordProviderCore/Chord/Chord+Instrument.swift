//
//  Chord+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The instruments we know about
    public enum Instrument: String, CaseIterable, Codable, Identifiable, Sendable, CustomStringConvertible {

        /// Make ``Instrument`` identifiable
        public var id: Self { self }

        /// Guitar Standard E tuning
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele Standard G tuning
        case ukulele
    }
}

extension Chord.Instrument {

    /// The description of the instrument
    public var description: String {
        rawValue.capitalized
    }

    /// The label of the instrument
    public var label: String {
        switch self {
        case .guitar:
            "Guitar, 6 strings, standard tuning"
        case .guitalele:
            "Guitalele, 6 strings, standard tuning"
        case .ukulele:
            "Ukulele, 4 strings, standard tuning"
        }
    }

    /// The tuning of the instrument
    public var tuning: [String] {
        var tuning: [String] = []
        for string in strings {
            let octave = ((offset[string] + 41) / 12) - 1
            tuning.append("\(stringName[string].display)\(octave)")
        }
        return tuning
    }

    /// The strings of the instrument
    public var strings: [Int] {
        switch self {
        case .ukulele:
            [0, 1, 2, 3]
        default:
            [0, 1, 2, 3, 4, 5]
        }
    }
    /// The name of the strings
    public var stringName: [Chord.Root] {
        switch self {
        case .guitar:
            [.e, .a, .d, .g, .b, .e]
        case .guitalele:
            [.a, .d, .g, .c, .e, .a]
        case .ukulele:
            [.g, .c, .e, .a]
        }
    }
    /// The offset for each string from the base 'E'
    ///  - Note: Start with -1, because of the BaseFret value in `ChordDefinition`
    public var offset: [Int] {
        switch self {
        case .guitar:
            [-1, 4, 9, 14, 18, 23]
        case .guitalele:
            [4, 9, 14, 19, 23, 28]
        case .ukulele:
            [26, 19, 23, 28]
        }
    }
}

extension Chord.Instrument {

    /// The databases for the instruments in the `Resources` folder
    public var database: String {
        switch self {
        case .guitar:
            "ChordDefinitions/GuitarStandardETuning"
        case .guitalele:
            "ChordDefinitions/GuitaleleStandardATuning"
        case .ukulele:
            "ChordDefinitions/UkuleleStandardGTuning"
        }
    }
}

//
//  Instrument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//


import Foundation

/// The instruments we know about
enum Instrument: String, CaseIterable, Codable, Identifiable, Sendable {

    /// Make ``Instrument`` identifiable
    var id: String {
        self.rawValue
    }

    /// Guitar Standard E tuning
    case guitarStandardETuning
    /// Guitalele
    case guitaleleStandardATuning
    /// Ukulele Standard G tuning
    case ukuleleStandardGTuning
}

extension Instrument {

    /// The label of the instrument
    var label: String {
        switch self {
        case .guitarStandardETuning:
            "Guitar"
        case .guitaleleStandardATuning:
            "Guitalele"
        case .ukuleleStandardGTuning:
            "Ukulele"
        }
    }

    /// The description of the instrument
    var description: String {
        switch self {
        case .guitarStandardETuning:
            "Guitar, 6 strings, standard tuning"
        case .guitaleleStandardATuning:
            "Guitalele, 6 strings, standard tuning"
        case .ukuleleStandardGTuning:
            "Ukulele, 4 strings, standard tuning"
        }
    }

    /// The tuning of the instrument
    var tuning: [String] {
        var tuning: [String] = []
        for string in strings {
            let octave = ((offset[string] + 41) / 12) - 1
            tuning.append("\(stringName[string].display)\(octave)")
        }
        return tuning
    }

    /// The strings of the instrument
    var strings: [Int] {
        switch self {
        case .ukuleleStandardGTuning:
            [0, 1, 2, 3]
        default:
            [0, 1, 2, 3, 4, 5]
        }
    }
    /// The name of the strings
    var stringName: [Chord.Root] {
        switch self {
        case .guitarStandardETuning:
            [.e, .a, .d, .g, .b, .e]
        case .guitaleleStandardATuning:
            [.a, .d, .g, .c, .e, .a]
        case .ukuleleStandardGTuning:
            [.g, .c, .e, .a]
        }
    }
    /// The offset for each string from the base 'E'
    ///  - Note: Start with -1, because of the BaseFret value in `ChordDefinition`
    var offset: [Int] {
        switch self {
        case .guitarStandardETuning:
            [-1, 4, 9, 14, 18, 23]
        case .guitaleleStandardATuning:
            [4, 9, 14, 19, 23, 28]
        case .ukuleleStandardGTuning:
            [26, 19, 23, 28]
        }
    }
}

extension Instrument {

    /// The databases for the instruments
    var database: String {
        switch self {
        case .guitarStandardETuning:
            "GuitarStandardETuning"
        case .guitaleleStandardATuning:
            "GuitaleleStandardATuning"
        case .ukuleleStandardGTuning:
            "UkuleleStandardGTuning"
        }
    }
}

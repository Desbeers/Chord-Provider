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
    case guitar
    /// Guitalele
    case guitalele
    /// Ukulele Standard G tuning
    case ukulele
}

extension Instrument {

    /// The label of the instrument
    var label: String {
        switch self {
        case .guitar:
            "Guitar"
        case .guitalele:
            "Guitalele"
        case .ukulele:
            "Ukulele"
        }
    }

    /// The description of the instrument
    var description: String {
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
        case .ukulele:
            [0, 1, 2, 3]
        default:
            [0, 1, 2, 3, 4, 5]
        }
    }
    /// The name of the strings
    var stringName: [Chord.Root] {
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
    var offset: [Int] {
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

extension Instrument {

    /// The databases for the instruments
    var database: String {
        switch self {
        case .guitar:
            "GuitarStandardETuning"
        case .guitalele:
            "GuitaleleStandardATuning"
        case .ukulele:
            "UkuleleStandardGTuning"
        }
    }
}

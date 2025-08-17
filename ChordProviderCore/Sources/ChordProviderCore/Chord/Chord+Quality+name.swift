//
//  Chord+Quality+name.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord.Quality {

    /// An array with all optional names for a ``Chord/Quality``
    /// - Note: Used to lookup a quality from a **ChordPro** definition
    var name: [String] {
        switch self {
        case .major:
            ["major", "maj", ""]
        case .minor:
            ["minor", "min", "m"]
        case .aug:
            ["aug", "+"]
        case .dim:
            ["dim"]
        case .seven:
            ["7"]
        case .sevenSharpFive:
            ["7#5"]
        case .sevenFlatFive:
            ["7b5"]
        case .sevenSharpNine:
            ["7#9"]
        case .sevenFlatNine:
            ["7b9"]
        case .minorSeven:
            ["m7"]
        case .majorSeven:
            ["maj7"]
        case .augSeven:
            ["aug7"]
        case .dimSeven:
            ["dim7"]
        case .majorSevenSharpFive:
            ["maj7#5"]
        case .majorSevenFlatFive:
            ["maj7b5"]
        case .minorMajorSeven:
            ["mmaj7", "mMaj7"]
        case .minorMajorSevenFlatFive:
            ["mmaj7b5", "mMaj7b5"]
        case .minorSevenFlatFive:
            ["m7b5"]
        case .susTwo:
            ["sus2"]
        case .susFour:
            ["sus4"]
        case .sevenSusTwo:
            ["7sus2"]
        case .sevenSusFour:
            ["7sus4"]
        case .nine:
            ["9"]
        case .majorNine:
            ["maj9"]
        case .minorMajorNine:
            ["mmaj9", "mMaj9"]
        case .minorNine:
            ["m9"]
        case .nineFlatFive:
            ["9b5"]
        case .nineSharpEleven:
            ["9#11"]
        case .eleven:
            ["11"]
        case .majorEleven:
            ["maj11"]
        case .minorEleven:
            ["m11"]
        case .minorMajorEleven:
            ["mmaj11", "mMaj11"]
        case .thirteen:
            ["13"]
        case .majorThirteen:
            ["maj13"]
        case .minorThirteen:
            ["m13"]
        case .five:
            ["5"]
        case .six:
            ["6"]
        case .minorSix:
            ["m6"]
        case .sixNine:
            ["6/9", "69"]
        case .minorSixNine:
            ["m6/9", "m69"]
        case .addFour:
            ["add4"]
        case .addNine:
            ["add9"]
        case .addEleven:
            ["add11"]
        case .minorAddNine:
            ["madd9"]
        case .augNine:
            ["aug9"]
        case .unknown:
            ["?"]
        }
    }
}

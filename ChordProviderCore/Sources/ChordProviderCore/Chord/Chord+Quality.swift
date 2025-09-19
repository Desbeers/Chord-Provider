//
//  Chord+Quality.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// All the chord qualities we know about
    /// - Note: Changes to the raw value might break the databases
    public enum Quality: String, CaseIterable, Codable, Comparable, Sendable {

        /// Fallback
        case unknown = "All Qualities"

        // MARK: Triad

        /// Major
        case major = ""
        /// Minor
        case minor = "m"
        /// Augmented
        case aug = "aug"
        /// Diminished
        case dim = "dim"

        // MARK: Seventh

        /// 7
        case seven = "7"
        /// 7#5
        case sevenSharpFive = "7#5"
        /// 7b5
        case sevenFlatFive = "7b5"
        /// 7#9
        case sevenSharpNine = "7#9"
        /// 7b9
        case sevenFlatNine = "7b9"
        /// Minor 7
        case minorSeven = "m7"
        /// Major 7
        case majorSeven = "maj7"
        /// Augmented 7
        case augSeven = "aug7"
        /// Diminished 7
        case dimSeven = "dim7"
        /// Major 7#5
        case majorSevenSharpFive = "maj7#5"
        /// Major 7b5
        case majorSevenFlatFive = "maj7b5"
        /// Minor Major 7
        case minorMajorSeven = "mMaj7"
        /// Minor Major 7b5
        case minorMajorSevenFlatFive = "mMaj7b5"
        /// Minor 7b5
        case minorSevenFlatFive = "m7b5"

        // MARK: Suspended

        /// Sus 2
        case susTwo = "sus2"
        /// Sus 4
        case susFour = "sus4"
        /// 7 sus 2
        case sevenSusTwo = "7sus2"
        /// 7 sus 4
        case sevenSusFour = "7sus4"

        // MARK: Extended

        /// 9
        case nine = "9"
        /// Major 9
        case majorNine = "maj9"
        /// Minor Major 9
        case minorMajorNine = "mMaj9"
        /// Minor 9
        case minorNine = "m9"
        /// 9b5
        case nineFlatFive = "9b5"
        /// 9#11
        case nineSharpEleven = "9#11"

        /// 11
        case eleven = "11"
        /// Major 11
        case majorEleven = "maj11"
        /// Minor 11
        case minorEleven = "m11"
        /// Minor Major 11
        case minorMajorEleven = "mMaj11"

        /// 13
        case thirteen = "13"
        /// Major 13
        case majorThirteen = "maj13"
        /// Minor 13
        case minorThirteen = "m13"

        // MARK: Added

        /// 5
        case five = "5"
        /// 6
        case six = "6"
        /// Minor 6
        case minorSix = "m6"
        /// 6/9
        case sixNine = "69"
        /// Minor 6/9
        case minorSixNine = "m69"
        /// Add 4
        case addFour = "add4"
        /// Add 9
        case addNine = "add9"
        /// Minor add 9
        case minorAddNine = "madd9"
        /// Add 11
        case addEleven = "add11"

        // MARK: Augmented

        /// Augmented 9
        case augNine = "aug9"

        /// Implement Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// The display of Quality
        public var display: String {
            switch self {
            case .unknown:                  "All"
            case .major:                    ""
            case .minor:                    "m"
            case .dim:                      "dim"
            case .dimSeven:                 "dim⁷"
            case .susTwo:                   "sus²"
            case .susFour:                  "sus⁴"
            case .sevenSusTwo:              "⁷sus²"
            case .sevenSusFour:             "⁷sus⁴"
            case .five:                     "⁵"
            case .aug:                      "aug"
            case .six:                      "⁶"
            case .sixNine:                  "⁶ᐟ⁹"
            case .seven:                    "⁷"
            case .sevenFlatFive:            "⁷♭⁵"
            case .augSeven:                 "aug⁷"
            case .nine:                     "⁹"
            case .nineFlatFive:             "⁹♭⁵"
            case .augNine:                  "aug⁹"
            case .sevenFlatNine:            "⁷♭⁹"
            case .sevenSharpNine:           "⁷♯⁹"
            case .sevenSharpFive:           "⁷♯⁵"
            case .eleven:                   "¹¹"
            case .nineSharpEleven:          "⁹♯¹¹"
            case .thirteen:                 "¹³"
            case .minorThirteen:            "m¹³"
            case .majorSeven:               "maj⁷"
            case .majorSevenFlatFive:       "maj⁷♭⁵"
            case .majorSevenSharpFive:      "maj⁷♯⁵"
            case .majorNine:                "maj⁹"
            case .majorEleven:              "maj¹¹"
            case .majorThirteen:            "maj¹³"
            case .minorSix:                 "m⁶"
            case .minorSixNine:             "m⁶ᐟ⁹"
            case .minorSeven:               "m⁷"
            case .minorSevenFlatFive:       "m⁷♭⁵"
            case .minorNine:                "m⁹"
            case .minorEleven:              "m¹¹"
            case .minorMajorSeven:          "mMaj⁷"
            case .minorMajorSevenFlatFive:  "mMaj⁷♭⁵"
            case .minorMajorNine:           "mMaj⁹"
            case .minorMajorEleven:         "mMaj¹¹"
            case .addFour:                  "add⁴"
            case .addNine:                  "add⁹"
            case .minorAddNine:             "madd⁹"
            case .addEleven:                "add¹¹"
            }
        }

        /// Supports a few most popular groupings. Major, Minor, Diminished, Augmented, Suspended.
        /// Please open a PR if you'd like to introduce more types or offer corrections.
        /// Anything that doesn't fit into the above categories are put in `other`.
        ///
        /// The intention for the group is for developers to offer different filter types for chart lookup.
        var group: Chord.Group {
            // swiftlint:disable line_length
            switch self {
            case .major, .majorSeven, .majorSevenFlatFive, .majorSevenSharpFive, .majorNine, .majorEleven, .majorThirteen, .addFour, .addNine, .addEleven:
                .major
            case .minor, .minorSix, .minorSixNine, .minorSeven, .minorEleven, .minorSevenFlatFive, .minorMajorSeven, .minorMajorSevenFlatFive, .minorMajorNine, .minorMajorEleven, .minorAddNine, .minorNine, .minorThirteen:
                .minor
            case .dim, .dimSeven:
                .diminished
            case .susTwo, .susFour, .sevenSusTwo, .sevenSusFour:
                .suspended
            case .aug, .augSeven, .augNine:
                .augmented
            case .five, .six, .sixNine, .seven, .sevenFlatFive, .nine, .nineFlatFive, .sevenFlatNine, .sevenSharpNine, .eleven, .nineSharpEleven, .thirteen, .sevenSharpFive, .unknown:
                .other
            }
            // swiftlint:enable line_length
        }
    }
}

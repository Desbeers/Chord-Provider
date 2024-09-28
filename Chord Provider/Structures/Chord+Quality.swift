//
//  Chord+Quality.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Chord {

    /// All the chord qualities we know about
    /// - Note: Changes to the raw value might break the databases
    public enum Quality: String, CaseIterable, Codable, Comparable, Sendable {

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

        // MARK: Other

        /// Fallback
        case unknown

        /// Implement Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        // swiftlint:disable large_tuple

        /// A suitible string for displaying to users.
        /// - `accessible:`  "seven flat five". Useful for text to speech.
        /// - `short:` Maj, min
        /// - `symbol:` dim⁷, + For the most common uses of symbols in music notation.
        /// - `altSymbol:` °, ⁺ Alternative examples of the above `symbol` examples.
        ///
        /// Advice is to look through this list and choose what is appropriate for your app. Please submit a PR if you'd like to add or change some of these items if you beleive it could be improved.
        /// Because of this, do not rely on these values to always remain the same. So don't use them as identifiers, or keys.
        ///
        /// For accessibility strings the "th" is dropped from numbers. While not completely accurate, it rolls better.
        ///
        /// Symbols use superscript where appropriate (and possible). Be aware that not all fonts will support this. Use `short` instead if you're unsure.
        ///
        /// Some items may also be identical across types. Only in rare cases will an alt symbol be provided e.g. (`dim⁷`,`°`)
        public var display: (accessible: String, short: String, symbolized: String, altSymbol: String) {
            switch self {
            case .major:
                ("major", "", "", "")
            case .minor:
                ("minor", "m", "m", "m")
            case .dim:
                ("diminished", "dim", "dim", "dim")
            case .dimSeven:
                ("dim seven", "dim7", "dim⁷", "°")
            case .susTwo:
                ("suss two", "sus2", "sus²", "sus²")
            case .susFour:
                ("suss four", "sus4", "sus⁴", "sus⁴")
            case .sevenSusTwo:
                ("seven sus two", "7sus2", "⁷sus²", "⁷sus²")
            case .sevenSusFour:
                ("seven sus four", "7sus4", "⁷sus⁴", "⁷sus⁴")
            case .five:
                ("power", "5", "⁵", "⁵")
            case .aug:
                ("augmented", "aug", "aug", "⁺")
            case .six:
                ("six", "6", "⁶", "⁶")
            case .sixNine:
                ("six slash nine", "6/9", "⁶ᐟ⁹", "⁶ᐟ⁹")
            case .seven:
                ("seven", "7", "⁷", "⁷")
            case .sevenFlatFive:
                ("seven flat five", "7b5", "⁷♭⁵", "⁷♭⁵")
            case .augSeven:
                ("org seven", "aug7", "aug⁷", "⁺⁷")
            case .nine:
                ("nine", "9", "⁹", "⁹")
            case .nineFlatFive:
                ("nine flat five", "9b5", "⁹♭⁵", "⁹♭⁵")
            case .augNine:
                ("org nine", "aug9", "aug⁹", "⁺⁹")
            case .sevenFlatNine:
                ("seven flat nine", "7b9", "⁷♭⁹", "⁷♭⁹")
            case .sevenSharpNine:
                ("seven sharp nine", "7#9", "⁷♯⁹", "⁷♯⁹")
            case .sevenSharpFive:
                ("dominant sharp five", "7#5", "⁷♯⁵", "⁷♯⁵")
            case .eleven:
                ("eleven", "11", "¹¹", "¹¹")
            case .nineSharpEleven:
                ("nine sharp eleven", "9#11", "⁹♯¹¹", "⁹♯¹¹")
            case .thirteen:
                ("thirteen", "13", "¹³", "¹³")
            case .minorThirteen:
                ("minor thirteen", "m13", "m¹³", "m¹³")
            case .majorSeven:
                ("major seven", "maj7", "maj⁷", "M⁷")
            case .majorSevenFlatFive:
                ("major seven flat five", "maj7b5", "maj⁷♭⁵", "M⁷♭⁵")
            case .majorSevenSharpFive:
                ("major seven sharp five", "maj7#5", "maj⁷♯⁵", "M⁷♯⁵")
            case .majorNine:
                ("major nine", "maj9", "maj⁹", "M⁹")
            case .majorEleven:
                ("major eleven", "maj11", "maj¹¹", "m¹¹")
            case .majorThirteen:
                ("major thirteen", "maj13", "maj¹³", "M¹³")
            case .minorSix:
                ("minor six", "m6", "m⁶", "m⁶")
            case .minorSixNine:
                ("minor six slash nine", "m6/9", "m⁶ᐟ⁹", "m⁶ᐟ⁹")
            case .minorSeven:
                ("minor seven", "m7", "m⁷", "m⁷")
            case .minorSevenFlatFive:
                ("minor seven flat five", "m7b5", "m⁷♭⁵", "ø⁷")
            case .minorNine:
                ("minor nine", "m9", "m⁹", "m⁹")
            case .minorEleven:
                ("minor eleven", "m11", "m¹¹", "m¹¹")
            case .minorMajorSeven:
                ("minor major seven", "mMaj7", "mMaj⁷", "mᴹ⁷")
            case .minorMajorSevenFlatFive:
                ("minor major seven flat five", "mMaj7b5", "mMaj⁷♭⁵", "mᴹ⁷♭⁵")
            case .minorMajorNine:
                ("minor major nine", "mMaj9", "mMaj⁹", "mᴹ⁹")
            case .minorMajorEleven:
                ("minor major eleven", "mMaj11", "mMaj¹¹", "mᴹ¹¹")
            case .addFour:
                ("add four", "add4", "add⁴", "ᵃᵈᵈ⁴")
            case .addNine:
                ("add nine", "add9", "add⁹", "ᵃᵈᵈ⁹")
            case .minorAddNine:
                ("minor add nine", "madd9", "madd⁹", "mᵃᵈᵈ⁹")
            case .addEleven:
                ("add eleven", "add11", "add¹¹", "ᵃᵈᵈ¹¹")
            case .unknown:
                ("unknown", "?", "?", "?")
            }
        }

        // swiftlint:enable large_tuple

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

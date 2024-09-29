//
//  Interval.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure for an interval
struct Interval: Hashable, Sendable, CustomStringConvertible {

    // swiftlint:disable identifier_name

    /// Quality of the interval
    var quality: Quality
    /// Degree of the interval
    var degree: Int
    /// Semitones interval affect on a pitch
    var semitones: Int

    /// Unison
    static let P1 = Interval(quality: .perfect, degree: 1, semitones: 0)
    /// Perfect fourth
    static let P4 = Interval(quality: .perfect, degree: 4, semitones: 5)
    /// Perfect fifth
    static let P5 = Interval(quality: .perfect, degree: 5, semitones: 7)
    /// Octave
    static let P8 = Interval(quality: .perfect, degree: 8, semitones: 12)
    /// Perfect eleventh
    static let P11 = Interval(quality: .perfect, degree: 11, semitones: 17)
    /// Perfect twelfth
    static let P12 = Interval(quality: .perfect, degree: 12, semitones: 19)
    /// Perfect fifteenth, double octave
    static let P15 = Interval(quality: .perfect, degree: 15, semitones: 24)

    /// Minor second
    static let m2 = Interval(quality: .minor, degree: 2, semitones: 1)
    /// Minor third
    static let m3 = Interval(quality: .minor, degree: 3, semitones: 3)
    /// Minor sixth
    static let m6 = Interval(quality: .minor, degree: 6, semitones: 8)
    /// Minor seventh
    static let m7 = Interval(quality: .minor, degree: 7, semitones: 10)
    /// Minor ninth
    static let m9 = Interval(quality: .minor, degree: 9, semitones: 13)
    /// Minor tenth
    static let m10 = Interval(quality: .minor, degree: 10, semitones: 15)
    /// Minor thirteenth
    static let m13 = Interval(quality: .minor, degree: 13, semitones: 20)
    /// Minor fourteenth
    static let m14 = Interval(quality: .minor, degree: 14, semitones: 22)

    /// Major second
    static let M2 = Interval(quality: .major, degree: 2, semitones: 2)
    /// Major third
    static let M3 = Interval(quality: .major, degree: 3, semitones: 4)
    /// Major sixth
    static let M6 = Interval(quality: .major, degree: 6, semitones: 9)
    /// Major seventh
    static let M7 = Interval(quality: .major, degree: 7, semitones: 11)
    /// Major ninth
    static let M9 = Interval(quality: .major, degree: 9, semitones: 14)
    /// Major tenth
    static let M10 = Interval(quality: .major, degree: 10, semitones: 16)
    /// Major thirteenth
    static let M13 = Interval(quality: .major, degree: 13, semitones: 21)
    /// Major fourteenth
    static let M14 = Interval(quality: .major, degree: 14, semitones: 23)

    /// Diminished first
    static let d1 = Interval(quality: .diminished, degree: 1, semitones: -1)
    /// Diminished second
    static let d2 = Interval(quality: .diminished, degree: 2, semitones: 0)
    /// Diminished third
    static let d3 = Interval(quality: .diminished, degree: 3, semitones: 2)
    /// Diminished fourth
    static let d4 = Interval(quality: .diminished, degree: 4, semitones: 4)
    /// Diminished fifth
    static let d5 = Interval(quality: .diminished, degree: 5, semitones: 6)
    /// Diminished sixth
    static let d6 = Interval(quality: .diminished, degree: 6, semitones: 7)
    /// Diminished seventh
    static let d7 = Interval(quality: .diminished, degree: 7, semitones: 9)
    /// Diminished eighth
    static let d8 = Interval(quality: .diminished, degree: 8, semitones: 11)
    /// Diminished ninth
    /// - Note: Changed 12 to 13
    static let d9 = Interval(quality: .diminished, degree: 9, semitones: 13)
    /// Diminished tenth
    static let d10 = Interval(quality: .diminished, degree: 10, semitones: 14)
    /// Diminished eleventh
    static let d11 = Interval(quality: .diminished, degree: 11, semitones: 16)
    /// Diminished twelfth
    static let d12 = Interval(quality: .diminished, degree: 12, semitones: 18)
    /// Diminished thirteenth
    static let d13 = Interval(quality: .diminished, degree: 13, semitones: 19)
    /// Diminished fourteenth
    static let d14 = Interval(quality: .diminished, degree: 14, semitones: 21)
    /// Diminished fifteenth
    static let d15 = Interval(quality: .diminished, degree: 15, semitones: 23)

    /// Augmented first
    static let A1 = Interval(quality: .augmented, degree: 1, semitones: 1)
    /// Augmented second
    static let A2 = Interval(quality: .augmented, degree: 2, semitones: 3)
    /// Augmented third
    static let A3 = Interval(quality: .augmented, degree: 3, semitones: 5)
    /// Augmented fourth
    static let A4 = Interval(quality: .augmented, degree: 4, semitones: 6)
    /// Augmented fifth
    static let A5 = Interval(quality: .augmented, degree: 5, semitones: 8)
    /// Augmented sixth
    static let A6 = Interval(quality: .augmented, degree: 6, semitones: 10)
    /// Augmented seventh
    static let A7 = Interval(quality: .augmented, degree: 7, semitones: 12)
    /// Augmented octave
    static let A8 = Interval(quality: .augmented, degree: 8, semitones: 13)
    /// Augmented ninth
    static let A9 = Interval(quality: .augmented, degree: 9, semitones: 15)
    /// Augmented tenth
    static let A10 = Interval(quality: .augmented, degree: 10, semitones: 17)
    /// Augmented eleventh
    static let A11 = Interval(quality: .augmented, degree: 11, semitones: 18)
    /// Augmented twelfth
    static let A12 = Interval(quality: .augmented, degree: 12, semitones: 20)
    /// Augmented thirteenth
    static let A13 = Interval(quality: .augmented, degree: 13, semitones: 22)
    /// Augmented fourteenth
    static let A14 = Interval(quality: .augmented, degree: 14, semitones: 24)
    /// Augmented fifteenth
    static let A15 = Interval(quality: .augmented, degree: 15, semitones: 25)

    // swiftlint:enable identifier_name

    // MARK: CustomStringConvertible

    /// Returns the name of the interval.
    var description: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let formattedDegree = formatter.string(from: NSNumber(value: Int32(degree))) ?? "\(degree)"
        return "\(quality) \(formattedDegree)"
    }
}

extension Interval {

    /// The quality of the interval
    enum Quality: Sendable {

        /// Perfect
        case perfect
        /// Major.
        case major
        /// Minor
        case minor
        /// Augmented
        /// - Note: major or perfect interval is increased by one semitone
        case augmented
        /// Diminished
        /// - Note: minor or perfect interval is decreased by one semitone
        case diminished

        // MARK: CustomStringConvertible

        /// Returns the notation of the interval quality
        var notation: String {
            switch self {
            case .perfect: "P"
            case .minor: "m"
            case .major: "M"
            case .augmented: "A"
            case .diminished: "d"
            }
        }

        /// Returns the name of the interval quality
        var description: String {
            switch self {
            case .perfect: "Perfect"
            case .minor: "Minor"
            case .major: "Major"
            case .augmented: "Augmented"
            case .diminished: "Diminished"
            }
        }
    }
}

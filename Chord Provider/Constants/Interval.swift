//
//  Interval.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure for an interval
public struct Interval: Hashable, Sendable, CustomStringConvertible {

    // swiftlint:disable identifier_name

    /// Quality of the interval
    public var quality: Quality
    /// Degree of the interval
    public var degree: Int
    /// Semitones interval affect on a pitch
    public var semitones: Int

    /// Unison
    public static let P1 = Interval(quality: .perfect, degree: 1, semitones: 0)
    /// Perfect fourth
    public static let P4 = Interval(quality: .perfect, degree: 4, semitones: 5)
    /// Perfect fifth
    public static let P5 = Interval(quality: .perfect, degree: 5, semitones: 7)
    /// Octave
    public static let P8 = Interval(quality: .perfect, degree: 8, semitones: 12)
    /// Perfect eleventh
    public static let P11 = Interval(quality: .perfect, degree: 11, semitones: 17)
    /// Perfect twelfth
    public static let P12 = Interval(quality: .perfect, degree: 12, semitones: 19)
    /// Perfect fifteenth, double octave
    public static let P15 = Interval(quality: .perfect, degree: 15, semitones: 24)

    /// Minor second
    public static let m2 = Interval(quality: .minor, degree: 2, semitones: 1)
    /// Minor third
    public static let m3 = Interval(quality: .minor, degree: 3, semitones: 3)
    /// Minor sixth
    public static let m6 = Interval(quality: .minor, degree: 6, semitones: 8)
    /// Minor seventh
    public static let m7 = Interval(quality: .minor, degree: 7, semitones: 10)
    /// Minor ninth
    public static let m9 = Interval(quality: .minor, degree: 9, semitones: 13)
    /// Minor tenth
    public static let m10 = Interval(quality: .minor, degree: 10, semitones: 15)
    /// Minor thirteenth
    public static let m13 = Interval(quality: .minor, degree: 13, semitones: 20)
    /// Minor fourteenth
    public static let m14 = Interval(quality: .minor, degree: 14, semitones: 22)

    /// Major second
    public static let M2 = Interval(quality: .major, degree: 2, semitones: 2)
    /// Major third
    public static let M3 = Interval(quality: .major, degree: 3, semitones: 4)
    /// Major sixth
    public static let M6 = Interval(quality: .major, degree: 6, semitones: 9)
    /// Major seventh
    public static let M7 = Interval(quality: .major, degree: 7, semitones: 11)
    /// Major ninth
    public static let M9 = Interval(quality: .major, degree: 9, semitones: 14)
    /// Major tenth
    public static let M10 = Interval(quality: .major, degree: 10, semitones: 16)
    /// Major thirteenth
    public static let M13 = Interval(quality: .major, degree: 13, semitones: 21)
    /// Major fourteenth
    public static let M14 = Interval(quality: .major, degree: 14, semitones: 23)

    /// Diminished first
    public static let d1 = Interval(quality: .diminished, degree: 1, semitones: -1)
    /// Diminished second
    public static let d2 = Interval(quality: .diminished, degree: 2, semitones: 0)
    /// Diminished third
    public static let d3 = Interval(quality: .diminished, degree: 3, semitones: 2)
    /// Diminished fourth
    public static let d4 = Interval(quality: .diminished, degree: 4, semitones: 4)
    /// Diminished fifth
    public static let d5 = Interval(quality: .diminished, degree: 5, semitones: 6)
    /// Diminished sixth
    public static let d6 = Interval(quality: .diminished, degree: 6, semitones: 7)
    /// Diminished seventh
    public static let d7 = Interval(quality: .diminished, degree: 7, semitones: 9)
    /// Diminished eighth
    public static let d8 = Interval(quality: .diminished, degree: 8, semitones: 11)
    /// Diminished ninth
    /// - Note: Changed 12 to 13
    public static let d9 = Interval(quality: .diminished, degree: 9, semitones: 13)
    /// Diminished tenth
    public static let d10 = Interval(quality: .diminished, degree: 10, semitones: 14)
    /// Diminished eleventh
    public static let d11 = Interval(quality: .diminished, degree: 11, semitones: 16)
    /// Diminished twelfth
    public static let d12 = Interval(quality: .diminished, degree: 12, semitones: 18)
    /// Diminished thirteenth
    public static let d13 = Interval(quality: .diminished, degree: 13, semitones: 19)
    /// Diminished fourteenth
    public static let d14 = Interval(quality: .diminished, degree: 14, semitones: 21)
    /// Diminished fifteenth
    public static let d15 = Interval(quality: .diminished, degree: 15, semitones: 23)

    /// Augmented first
    public static let A1 = Interval(quality: .augmented, degree: 1, semitones: 1)
    /// Augmented second
    public static let A2 = Interval(quality: .augmented, degree: 2, semitones: 3)
    /// Augmented third
    public static let A3 = Interval(quality: .augmented, degree: 3, semitones: 5)
    /// Augmented fourth
    public static let A4 = Interval(quality: .augmented, degree: 4, semitones: 6)
    /// Augmented fifth
    public static let A5 = Interval(quality: .augmented, degree: 5, semitones: 8)
    /// Augmented sixth
    public static let A6 = Interval(quality: .augmented, degree: 6, semitones: 10)
    /// Augmented seventh
    public static let A7 = Interval(quality: .augmented, degree: 7, semitones: 12)
    /// Augmented octave
    public static let A8 = Interval(quality: .augmented, degree: 8, semitones: 13)
    /// Augmented ninth
    public static let A9 = Interval(quality: .augmented, degree: 9, semitones: 15)
    /// Augmented tenth
    public static let A10 = Interval(quality: .augmented, degree: 10, semitones: 17)
    /// Augmented eleventh
    public static let A11 = Interval(quality: .augmented, degree: 11, semitones: 18)
    /// Augmented twelfth
    public static let A12 = Interval(quality: .augmented, degree: 12, semitones: 20)
    /// Augmented thirteenth
    public static let A13 = Interval(quality: .augmented, degree: 13, semitones: 22)
    /// Augmented fourteenth
    public static let A14 = Interval(quality: .augmented, degree: 14, semitones: 24)
    /// Augmented fifteenth
    public static let A15 = Interval(quality: .augmented, degree: 15, semitones: 25)

    // swiftlint:enable identifier_name

    // MARK: CustomStringConvertible

    /// Returns the name of the interval.
    public var description: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        let formattedDegree = formatter.string(from: NSNumber(value: Int32(degree))) ?? "\(degree)"
        return "\(quality) \(formattedDegree)"
    }
}

public extension Interval {

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
        public var notation: String {
            switch self {
            case .perfect: "P"
            case .minor: "m"
            case .major: "M"
            case .augmented: "A"
            case .diminished: "d"
            }
        }

        /// Returns the name of the interval quality
        public var description: String {
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

//
//  Chord+BaseFret.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Chord {

    /// The base fret of a chord
    public enum BaseFret: Int, CaseIterable, Codable, Comparable, Sendable, Identifiable, CustomStringConvertible {

        /// Identifiable protocol
        public var id: Self { self }

        /// CustomStringConvertible protocol
        public var description: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter.string(from: NSNumber(value: Int32(self.rawValue))) ?? "ERROR"
        }

        /// Comparable protocol
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// First fret
        case one = 1
        /// Second fret
        case two
        /// Third fret
        case three
        /// Fourth fret
        case four
        /// Fifth fret
        case five
        /// Sixth fret
        case six
        /// Seventh fret
        case seven
        /// Eighth fret
        case eight
        /// Ninth fret
        case nine
        /// Tenth fret
        case ten
        /// Eleventh fret
        case eleven
        /// Twelfth fret
        case twelve
        /// Thirteenth fret
        case thirteen
        /// Fourteenth fret
        case fourteen
        /// Fifteenth fret
        case fifteen
        /// Sixteenth fret
        case sixteen
        /// Seventeenth fret
        case seventeen
        /// Eighteenth fret
        case eighteen
        /// Nineteenth fret
        case nineteen
        /// Twentieth fret
        case twenty
    }
}

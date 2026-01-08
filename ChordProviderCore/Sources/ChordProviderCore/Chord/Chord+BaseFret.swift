//
//  Chord+BaseFret.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Chord {

    /// The root of a chord
    public enum BaseFret: Int, CaseIterable, Codable, Comparable, Sendable, Identifiable, CustomStringConvertible {

        /// Identifiable protocol
        public var id: Self { self }

        /// CustomStringConvertible protocol
        public var description: String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter.string(from: NSNumber(value: Int32(self.rawValue))) ?? "ERROR"
        }

        /// Implement Comparable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        // swiftlint:disable identifier_name
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
        case thirteen
        case fourteen
        case fifteen
        case sixteen
        case seventeen
        case eighteen
        case nineteen
        case twenty
    }
}

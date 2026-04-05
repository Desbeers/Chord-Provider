//
//  Instrument+Kind.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Instrument {

    /// The instruments we know about
    public enum Kind: String, CaseIterable, Codable, Sendable, Comparable {

        /// Identifiable protocol
        public var id: Self { self }
        /// CustomStringConvertible protocol
        public var description: String {
            rawValue.capitalized
        }

        /// Comparable protocol
        /// - Note: Used for sorting
        public static func < (lhs: Self, rhs: Self) -> Bool {
            allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 1
        }

        /// Guitar
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele
        case ukulele
    }
}

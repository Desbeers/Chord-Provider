//
//  Instrument+Kind.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Instrument {

    /// The instruments we know about
    public enum Kind: String, CaseIterable, Codable, Sendable {

        /// Identifiable protocol
        public var id: Self { self }
        /// CustomStringConvertible protocol
        public var description: String {
            rawValue.capitalized
        }

        /// Guitar
        case guitar
        /// Guitalele
        case guitalele
        /// Ukulele
        case ukulele
    }
}

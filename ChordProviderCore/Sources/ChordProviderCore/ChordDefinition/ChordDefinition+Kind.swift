//
//  ChordDefinition+Kind.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// The kind of chord definition
    public enum Kind: String, Sendable, Codable, CustomStringConvertible {

        // MARK: Definition Kinds

        /// A standard chord from the database
        case standardChord
        /// A transposed chord
        case transposedChord
        /// A custom defined chord
        case customChord
        /// A custom defined chord that is transposed
        case customTransposedChord
        /// The definition is just text; eg [*Text]
        case textChord
        /// An unknown chord
        case unknownChord
        /// A transposed chord that is unknown
        case transposedUnknownChord

        /// CustomStringConvertible protocol
        public var description: String {
            switch self {
            case .unknownChord:
                "This chord is unknown"
            case .customTransposedChord:
                "A custom chord has no diagram when it is transposed"
            case .transposedUnknownChord:
                "This transposed chord is unknown"
            default:
                rawValue
            }
        }
    }

}

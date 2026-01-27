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

        /// Bool if the chord is considered 'known' and can have a diagram
        public var knownChord: Bool {
            switch self {
            case .standardChord, .transposedChord, .customChord:
                true
            default:
                false
            }
        }

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
                self.rawValue
            }
        }
    }

}

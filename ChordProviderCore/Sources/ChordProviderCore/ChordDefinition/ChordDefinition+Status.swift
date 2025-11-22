//
//  ChordDefinition+Status.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    // MARK: The status of a `ChordDefinition`

    /// The status of the ``ChordDefinition``
    public enum Status: String, LocalizedError, Codable {

        /// A standard chord from the database
        case standardChord
        /// A transposed chord
        case transposedChord
        /// A transposed chord that is unknown
        case transposedUnknownChord
        /// A custom defined chord
        case customChord
        /// A custom defined chord that is transposed
        case customTransposedChord
        /// An unknown chord
        case unknownChord
        /// The definition has too many frets
        case toManyFrets
        /// The definition has not enough frets
        case notEnoughFrets
        /// The definition has a wrong bass note
        case wrongBassNote
        /// The definition has a wrong root note
        case wrongRootNote
        /// The definition contains wrong notes
        case wrongNotes
        /// The definition contains wrong fingers
        case wrongFingers
        /// The definition is missing fingers
        case missingFingers
        /// The definition is a copy of another definition
        case chordIsCopy
        /// There are no chords defined
        case noChordsDefined
        /// The definition is correct
        case correct
        /// The definition is just text; eg [*Text]
        case textChord
        /// Add a definition
        case addDefinition = "Add chord definition"
        /// Edit a definition
        case editDefinition = "Edit chord definition"

        // MARK: Protocol items

        /// The description of the status
        public var description: String {
            switch self {
            case .toManyFrets:
                "Too many frets"
            case .notEnoughFrets:
                "Not enough frets"
            case .customTransposedChord:
                "A custom chord can not be transposed in the diagram"
            case .transposedUnknownChord:
                "This transposed chord is unknown"
            case .unknownChord:
                "This chord is unknown"
            case .correct:
                "The chord seems correct"
            case .wrongBassNote:
                "The chord does not start with the bass note"
            case .wrongRootNote:
                "The chord does not start with the root note"
            case .wrongNotes:
                "The chord contains incorrect notes"
            case .wrongFingers:
                "The chord contains incorrect fingers"
            case .missingFingers:
                "The chord is missing fingers"
            default:
                self.rawValue
            }
        }
        /// The error description of the status
        public var errorDescription: String? {
            description
        }

        /// The recovery suggestion of the status
        public var recoverySuggestion: String? {
            switch self {
            case .unknownChord:
                "this definition does not have a valid chord name"
            case .toManyFrets:
                "You can not edit this chord definition because it has to many frets defined for you current instrument."
            case .notEnoughFrets:
                "You can not edit this chord definition because it has not enough frets defined for you current instrument."
            default:
                "No Recovery suggestion"
            }
        }

        // MARK: Custom

        /// Bool if the chord is considered 'known'
        public var knownChord: Bool {
            switch self {
            case .standardChord, .transposedChord, .customChord, .customTransposedChord, .correct:
                true
            default:
                false
            }
        }
    }
}

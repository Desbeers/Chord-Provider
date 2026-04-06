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
    public enum Status: LocalizedError, Codable, Hashable, Comparable {

        /// Comparable protocol
        public static func < (lhs: Status, rhs: Status) -> Bool {
            lhs.sortOrder < rhs.sortOrder
        }

        // MARK: Validation

        /// An unknown status
        case unknownStatus
        /// An unknown chord
        case unknownChord
        /// The definition is missing required notes
        case missingRequiredNotes(notes: String)
        /// The definition contains wrong notes
        case wrongNotes(notes: String)
        /// The definition has too many frets
        case tooManyFrets
        /// The definition has not enough frets
        case notEnoughFrets
        /// The definition has a wrong bass note
        case wrongBassNote(bass: String)
        /// The definition has a wrong root note
        case wrongRootNote(root: String)
        /// The definition contains wrong fingers
        case wrongMutedFingers
        /// The definition contains wrong fingers
        case wrongOpenFingers
        /// The definition is missing fingers for fretted strings
        case missingFingers
        /// The definition has too many frets
        case tooManyFingers
        /// The definition has not enough frets
        case notEnoughFingers
        /// The definition has no notes
        case noNotes
        /// The definition has too many errors
        case tooManyErrors
        /// The definition is just text
        case text
        /// The definition is correct
        case correct

        // MARK: Protocol items

        /// The description of the status
        public var description: String {
            switch self {
            case .unknownStatus:
                "The status is unknown"
            case .missingRequiredNotes(let notes):
                "The chord is missing required notes: <b>\(notes)</b>"
            case .tooManyFrets:
                "The definition has too many frets and will be ignored"
            case .notEnoughFrets:
                "The chord has not enough frets and will be ignored"
            case .unknownChord:
                "The chord is unknown"
            case .correct:
                "The chord seems correct"
            case .wrongBassNote(let bass):
                "The chord does not start with <b>\(bass)</b> as bass note"
            case .wrongRootNote(let root):
                "The chord does not start with <b>\(root)</b> as root note"
            case .wrongNotes(let notes):
                "The chord contains incorrect notes: <b>\(notes)</b>"
            case .wrongMutedFingers:
                "Muted strings cannot have a finger position"
            case .wrongOpenFingers:
                "Open strings cannot have a finger position"
            case .tooManyFingers:
                "The chord has too many fingers and will be ignored"
            case .notEnoughFingers:
                "The chord has not enough fingers and will be ignored"
            case .missingFingers:
                "The chord is missing fingers for fretted strings"
            case .noNotes:
                "The chord has no notes"
            case .tooManyErrors:
                "The chord has too many errors and will be ignored"
            default:
                "Unknown"
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
                "This definition does not have a valid chord name"
            case .tooManyFrets:
                "You can not edit this chord definition because it has to many frets defined for you current instrument."
            case .notEnoughFrets:
                "You can not edit this chord definition because it has not enough frets defined for you current instrument."
            default:
                "No Recovery suggestion"
            }
        }

        private var sortOrder: Int {
            switch self {
            case .tooManyErrors: -1
            case .unknownStatus: 0
            case .unknownChord: 1
            case .tooManyFrets: 2
            case .notEnoughFrets: 3
            case .tooManyFingers: 4
            case .notEnoughFingers: 5
            case .missingRequiredNotes: 6
            case .wrongNotes: 7
            case .wrongBassNote: 8
            case .wrongRootNote: 9
            case .wrongMutedFingers: 10
            case .wrongOpenFingers: 11
            case .missingFingers: 12
            case .noNotes: 13
            case .text: 14
            case .correct: 15
            }
        }

        /// Bool if the status is considered an error
        public static var errorStatus: [Status] {
            [
                .unknownStatus,
                .unknownChord,
                .tooManyFrets,
                .notEnoughFrets,
                .tooManyFingers,
                .notEnoughFingers,
                .tooManyErrors
            ]
        }
    }
}

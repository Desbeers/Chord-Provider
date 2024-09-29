//
//  Chord+Status.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension Chord {

    // MARK: Status of a `ChordDefinition`

    /// Status of the ``ChordDefinition``
    enum Status: String, LocalizedError {

        /// A standard chord from the database
        case standardChord
        /// A transposed chord
        case transposedChord
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

        /// The definition is correct
        case correct
        /// The definition has a wrong bass note
        case wrongBassNote
        /// The definition has a wrong root note
        case wrongRootNote
        /// The definition contains wrong notes
        case wrongNotes
        /// The definition contains wrong fingers
        case wrongFingers

        // MARK: Protocol items

        /// The description of the status
        var description: String {
            switch self {

            case .toManyFrets:
                "To many frets"
            case .notEnoughFrets:
                "Not enough frets"
            case .customTransposedChord:
                "A custom chord can not be transposed in the diagram"
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
            default:
                self.rawValue
            }
        }
        /// The error description of the status
        var errorDescription: String? {
            description
        }

        /// The recovery suggestion of the status
        var recoverySuggestion: String? {
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

        /// The color for a label
        var color: Color {
            switch self {
            case .correct:
                Color.accentColor
            case .wrongBassNote:
                Color.red
            case .wrongRootNote:
                Color.purple
            case .wrongNotes:
                Color.red
            case .wrongFingers:
                Color.brown
            default:
                Color.primary
            }
        }
    }
}

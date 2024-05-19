//
//  ChordProviderError.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

enum ChordProviderError: String, LocalizedError {
    case createPdfError
    case exportFolderError
    case noAccessToSongError
    case saveSettingsError
    case writeDocumentError

    /// The chord definition is not valid
    case wrongChordDefinitionError

    // MARK: Protocol items

    /// The description of the status
    public var description: String {
        switch self {
        case .wrongChordDefinitionError:
            "The chord definition is not valid"
        default:
            self.rawValue
        }
    }
    /// The error description of the status
    public var errorDescription: String? {
        description
    }

    /// The recovery suggestion of the status
    var recoverySuggestion: String? {
        switch self {
        case .wrongChordDefinitionError:
            "You can not edit this chord definition because it is not complete or maybe it is for another instrument."
        default:
            ""
        }
    }
}

//
//  AppError.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// All errors that can happen in the application
enum AppError: String, LocalizedError {

    /// An error when creating a PDF
    case createPdfError
    /// An error when the is no access to the song folder
    case noAccessToSongError
    /// An error when saving the application settings
    case saveSettingsError
    /// An error when reading the document
    case readDocumentError
    /// An error when writing the document
    case writeDocumentError
    /// An error when a custom file is not found
    case customFileNotFound
    /// The song is empty
    case emptySong

    // MARK: Settings related

    /// The theme could not be imported
    case importThemeError
    /// The theme could not be exported
    case exportThemeError

    // MARK: Songs folder

    /// There is no folder with songs selected
    case noSongsFolderSelectedError
    /// There is a songs folder selected
    case songsFolderIsSelected

    // MARK: ChordPro integration

    /// An error if the  **ChordPro** CLI binary is not found
    case chordProCLINotFound
    /// An error when creating a PDF with the **ChordPro** CLI
    case createChordProCLIError
    /// A warning when creating a PDF with the **ChordPro** CLI
    case createChordProCLIWarning

    // MARK: JSON

    /// DecoderError
    case jsonDecoderError

    // MARK: Fallback

    /// An unknown status
    case unknownStatus
    /// Not an error
    case noErrorOccurred

    // MARK: Protocol items

    /// The description of the status
    var description: String {
        switch self {
        case .noSongsFolderSelectedError:
            "No songs folder selected"
        case .chordProCLINotFound:
            "The ChordPro CLI was not found"
        case .createChordProCLIError:
            "The ChordPro CLI could not create a PDF"
        case .createChordProCLIWarning:
            "The ChordPro CLI created a PDF with warnings"
        case .emptySong:
            "The song appears to be empty"
        case .importThemeError:
            "The theme settings could not be imported"
        default:
            self.rawValue
        }
    }
    /// The error description of the status
    var errorDescription: String? {
        description
    }

    // swiftlint:disable all

    /// The recovery suggestion of the status
    var recoverySuggestion: String? {
        switch self {
        case .importThemeError:
            "The JSON file seems not correct"
        case .noSongsFolderSelectedError:
"""
You have defined a song but it was not found.

You have not selected a folder with your songs. Chord Provider needs to know where your songs are to be able to play it.
"""
        case .chordProCLINotFound:
"""
It looks like the ChordPro CLI is not installed or it is not in your $path.
"""
        case .createChordProCLIError:
"""
Sorry... Please use its official GUI for diagnostics.
"""
        default:
            nil
        }
    }

    // swiftlint:enable all

    /// The help anchor of the status
    /// - Note: Used as the label button for an alert or confirmation dialog
    var helpAnchor: String? {
        switch self {
        case .noSongsFolderSelectedError:
            "Select Folder"
        default:
            "OK"
        }
    }
}

//
//  ChordProviderError.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

enum ChordProviderError: String, LocalizedError {

    /// An error when creating a PDF
    case createPdfError
    /// An error when the is no access to the song folder
    case noAccessToSongError
    /// An error when saving the application settings
    case saveSettingsError
    /// An error when writing the document
    case writeDocumentError

    // MARK: Songs folder

    /// There is no folder with songs selected
    case noSongsFolderSelectedError
    /// There is a songs folder selected
    case songsFolderIsSelected

    // MARK: Audio

    /// The audio file was not found
    case audioFileNotFoundError
    /// The audio file is not yet downloaded
    case audioFileNotDownloadedError
    /// The audio file is ready to play
    case readyToPlay

    // MARK: Fallback

    /// An unknown status
    case unknownStatus

    // MARK: Protocol items

    /// The description of the status
    public var description: String {
        switch self {
        case .audioFileNotFoundError:
            "The song was not found"
        case .audioFileNotDownloadedError:
            "The song is not downloaded"
        case .noSongsFolderSelectedError:
            "No songs folder selected"
        default:
            self.rawValue
        }
    }
    /// The error description of the status
    public var errorDescription: String? {
        description
    }

    // swiftlint:disable all

    /// The recovery suggestion of the status
    var recoverySuggestion: String? {
        switch self {
        case .audioFileNotFoundError:
"""
You have defined a song but it was not found.

It has to be in the same folder as your ChordPro file to be playable.

Both have to be in the selected 'songs folder'.
"""
        case .audioFileNotDownloadedError:
            "This song is not yet downloaded from your iCloud and can not be played."
        case .noSongsFolderSelectedError:
"""
You have defined a song but it was not found.

You have not selected a folder with your songs. Chord Provider needs to know where your songs are to be able to play it.
"""
        default:
            self.rawValue
        }
    }

    // swiftlint:enable all

    /// The help anchor of the status
    /// - Note: Used as the label button for an alert or confirmation dialog
    var helpAnchor: String? {
        switch self {
        case .audioFileNotDownloadedError:
            "Download"
        case .noSongsFolderSelectedError, .audioFileNotFoundError:
            "Select Folder"
        default:
            "OK"
        }
    }

    // MARK: Custom items

    /// The icon of the status
    var icon: Image {
        switch self {
        case .audioFileNotDownloadedError:
            Image(systemName: "icloud.and.arrow.down")
        case .noSongsFolderSelectedError:
            Image(systemName: "folder.badge.questionmark")
        case .readyToPlay:
            Image(systemName: "play.fill")
        default:
            Image(systemName: "questionmark")
        }
    }
}

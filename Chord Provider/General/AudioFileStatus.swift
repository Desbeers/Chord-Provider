//
//  AudioFileStatus.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// swiftlint:disable all

/// The status of an audio file
enum AudioFileStatus: String, LocalizedError {
    /// The song was not found
    case songNotFound
    /// The song is not yet downloaded
    case songNotDownloaded
    /// There is no folder with songs selected
    case noFolderSelected
    /// The song is ready
    case ready
    /// An unknown status
    case unknown

    // MARK: Protocol items

    /// The description of the status
    public var description: String {
        switch self {
        case .songNotFound:
            "The song was not found"
        case .songNotDownloaded:
            "The song is not downloaded"
        case .noFolderSelected:
            "No songs folder selected"
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
        case .songNotFound:
"""
You have defined a song but it was not found.

It has to be in the same folder as your ChordPro file to be playable.

Both have to be in the selected 'songs folder'.
"""
        case .songNotDownloaded:
            "This song is not yet downloaded from your iCloud and can not be played."
        case .noFolderSelected:
"""
You have defined a song but it was not found.

You have not selected a folder with your songs. Chord Provider needs to know where your songs are to be able to play it.
"""
        default:
            self.rawValue
        }
    }

    /// The help anchor of the status
    /// - Note: Used as the label button for an alert or confirmation dialog
    var helpAnchor: String? {
        switch self {
        case .songNotDownloaded:
            "Download"
        case .noFolderSelected, .songNotFound:
            "Select Folder"
        default:
            "OK"
        }
    }

    // MARK: Custom items

    /// The icon of the status
    var icon: Image {
        switch self {
        case .songNotFound:
            Image(systemName: "questionmark")
        case .songNotDownloaded:
            Image(systemName: "icloud.and.arrow.down")
        case .noFolderSelected:
            Image(systemName: "folder.badge.questionmark")
        case .ready:
            Image(systemName: "play.fill")
        case .unknown:
            Image(systemName: "questionmark")
        }
    }

    // MARK: Static help

    /// Static help message for the folder selector
    static let help =
"""
Chord Provider would like to know where to find your songs.

If you add a **'musicpath'** to your ChordPro file, Chord Provider can play the song if it knows where to look for it. The song has to be in the same folder as your ChordPro file.
"""
    /// Static help message for the file browser
    static let browser =
"""
If you have selected a folder, this welcome message will be replaced with a list of your songs and is searchable.
"""
}

// swiftlint:enable all

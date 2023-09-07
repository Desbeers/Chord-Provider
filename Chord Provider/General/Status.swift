//
//  Status.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// swiftlint:disable all

/// The status of a song
enum Status: String, LocalizedError {
    case songNotFound
    case songNotDownloaded
    case noFolderSelected
    case ready
    case unknown

    // MARK: Protocol items

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

    public var errorDescription: String? {
        description
    }

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

    var helpAnchor: String? {
        switch self {
        case .songNotDownloaded:
            "Download"
        default:
            "OK"
        }
    }

    // MARK: Custom items

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

    static let help = 
"""
Chord Provider would like to know where to find your songs.

If you add a **'musicpath'** to your ChordPro file, Chord Provider can play the song if it knows where to look for it. The song has to be in the same folder as your ChordPro file.
"""
    static let browser = 
"""
If you have selected a folder, this welcome message will be replaced with a list of your songs and is searchable.
"""
}

// swiftlint:enable all

//
//  Status.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// swiftlint:disable all

/// The status of a song
enum Status: String {
    case notFound
    case notDownloaded
    case noFolder
    case ready
    case unknown

    var icon: Image {
        switch self {
        case .notFound:
            Image(systemName: "questionmark")
        case .notDownloaded:
            Image(systemName: "icloud.and.arrow.down")
        case .noFolder:
            Image(systemName: "folder.badge.questionmark")
        case .ready:
            Image(systemName: "play.fill")
        case .unknown:
            Image(systemName: "questionmark")
        }
    }

    var title: String {
        switch self {
        case .notFound:
            "The song was not found"
        case .notDownloaded:
            "Not downloaded"
        case .noFolder:
            "No songs folder selected"
        default:
            self.rawValue
        }
    }

    func message(song: String) -> String {
        switch self {
        case .notFound:
"""
You have defined '\(song)' but it was not found.

It has to be in the same folder as your ChordPro file to be playable.

Both have to be in the selected 'songs folder'.
"""
        case .notDownloaded:
            "'\(song)' is not yet downloaded from your iCloud and can not be played."
        case .noFolder:
"""
You have defined '\(song)' but it was not found.

You have not selected a folder with your songs. Chord Provider needs to know where your songs are to be able to play it.
"""
        default:
            self.rawValue
        }
    }

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

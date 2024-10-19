//
//  CustomFile.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation
import UniformTypeIdentifiers

/// All files that can be selected by a user
enum UserFileItem: String, UserFile {
    /// The folder with songs
    case songsFolder
    /// An export folder
    case exportFolder
    /// A custom song template
    case customSongTemplate
    /// The ID of the file item
    var id: String {
        return self.rawValue
    }
    /// The `UTType`s of the file
    var utTypes: [UTType] {
        switch self {
        case .songsFolder:
            [UTType.folder]
        case .exportFolder:
            [UTType.folder]
        case .customSongTemplate:
            [UTType.chordProSong]
        }
    }
    /// The optional calculated label of the file
    var label: String? {
        return UserFileBookmark.getBookmarkURL(self)?.deletingPathExtension().lastPathComponent
    }
    /// The SF icon of the file
    var icon: String {
        switch self {
        case .songsFolder:
            "folder"
        case .exportFolder:
            "folder"
        case .customSongTemplate:
            "music.note.list"
        }
    }
    /// The message for the file sheet
    var message: String {
        switch self {
        case .songsFolder:
            "Select the folder with your songs"
        case .exportFolder:
            "Select the folder with the songs to export"
        case .customSongTemplate:
            "Select your custom template"
        }
    }
}

//
//  UserFileUtils+Selection.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import UniformTypeIdentifiers

extension UserFileUtils {

    /// All files that can be selected by a user
    enum Selection: String {
        /// The folder with songs
        case songsFolder
        /// An export folder
        case exportFolder
        /// A custom song template
        case customSongTemplate
        /// An image
        case image
        /// A custom configuration for the ChordPro CLI
        case customChordProConfig
        /// A custom configuration for the ChordPro CLI
        case customChordProLibrary
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
            case .image:
                [UTType.image]
            case .customChordProConfig:
                [UTType.json]
            case .customChordProLibrary:
                [UTType.folder]
            }
        }
        /// The optional calculated label of the file
        var label: String? {
            self.getBookmarkURL?.deletingPathExtension().lastPathComponent
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
            case .image:
                "photo"
            case .customChordProConfig:
                "gear"
            case .customChordProLibrary:
                "building.columns"
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
            case .image:
                "Select an image"
            case .customChordProConfig:
                "Select your custom ChordPro template"
            case .customChordProLibrary:
                "Select your custom ChordPro library"
            }
        }
    }
}

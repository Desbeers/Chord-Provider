//
//  AppState.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable application state for **Chord Provider**
@MainActor @Observable final class AppStateModel {
    /// The list with recent files
    var recentFiles: [URL] = []
    /// The optional current song in focus
    var song: Song?
    /// Last time the app state was updated
    var lastUpdate: Date = .now
    /// The ID of the app state
    var id: AppStateID
    /// The application settings
    var settings: AppSettings {
        didSet {
            try? AppSettings.save(id: id, settings: settings)
        }
    }

    var media = MediaPlayerView.Item()

    /// Init the class; get application settings
    init(id: AppStateID) {
        self.id = id
        /// Get the application settings from the cache
        let settings = AppSettings.load(id: id)
        self.settings = settings
    }
}

extension AppStateModel {

    /// Add the user settings as arguments to **ChordPro** for the Terminal action
    /// - Parameter settings: The ``AppSettings``
    /// - Returns: An array with arguments
    static func getUserSettings(settings: AppSettings) -> [String] {
        /// Start with an empty array
        var arguments: [String] = []
        /// Optional show only the lyrics
        if settings.song.display.lyricsOnly {
            arguments.append("--lyrics-only")
        }
        /// Return the basic settings
        return arguments
    }
}

extension AppStateModel {

    /// The ID of the app state
    /// - Note: Used to load and save the settings in the cache
    enum AppStateID: String {
        case mainView = "Main Settings"
        case exportFolderView = "Export Settings"
        case chordsDatabaseView = "Database Settings"
    }
}

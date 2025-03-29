//
//  AppState.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
    /// The ID of the app window
    var id: AppSettings.AppWindowID
    /// The application settings
    var settings: AppSettings {
        didSet {
            try? AppSettings.save(id: id, settings: settings)
        }
    }
    /// The optional media next to the song
    var media = MediaPlayerView.Item()

    let fontFamilies = NSFontManager.shared.availableFontFamilies.sorted()

    /// Init the class; get application settings
    init(id: AppSettings.AppWindowID) {
        self.id = id
        /// Get the application window settings from the cache
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

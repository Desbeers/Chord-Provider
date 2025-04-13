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
    /// All available font families
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
    /// - Parameter config: The ``AppSettings``
    /// - Returns: An array with arguments
    static func applyUserSettings(config: String, settings: AppSettings) -> String {
        var config = config
        /// Optional show only the lyrics
        if settings.shared.lyricsOnly {
            config = config.replacingOccurrences(of: "settings.lyrics-only : false", with: "settings.lyrics-only : true")
        }
        if settings.shared.repeatWholeChorus {
            config = config.replacingOccurrences(of: "pdf.chorus.recall.quote : false", with: "pdf.chorus.recall.quote : true")
        }
        if settings.diagram.showFingers {
            config = config.replacingOccurrences(of: "pdf.diagrams.fingers : false", with: "pdf.diagrams.fingers : true")
        }
        /// Return the config
        return config
    }
}

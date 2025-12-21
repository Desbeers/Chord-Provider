//
//  AppState.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore
import Observation

/// The observable application state for **Chord Provider**
@MainActor
@Observable
final class AppStateModel {
    /// The list with recent files
    var recentFiles: [URL] = []
    /// The optional current song in focus
    var song: Song?
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
    var fontFamilies: [String] = []
    /// All available fonts
    var fonts: [FontUtils.Item] = []

    /// Init the class; get application settings
    init(id: AppSettings.AppWindowID) {
        /// Create the temporarily directory
        try? FileManager.default.createDirectory(at: ChordProviderSettings.temporaryDirectoryURL, withIntermediateDirectories: true)
        self.id = id
        /// Get the application window settings from the cache
        let settings = AppSettings.load(id: id)
        self.settings = settings
        /// Get all fonts
        let allFonts = FontUtils.getAllFonts()
        self.fonts = allFonts.fonts
        self.fontFamilies = allFonts.families
    }
}

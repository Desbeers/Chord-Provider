//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable application state for **Chord Provider**
@Observable @MainActor final class AppStateModel {
    /// The shared instance of the class
    static let shared = AppStateModel(id: .mainView)
    /// The list with recent files
    var recentFiles: [URL] = []
    /// The standard content for a new document
    var standardDocumentContent: String
    /// The actual content for a new song
    /// - Note: This will be different thah the standard when opened from the ``WelcomeView``
    var newDocumentContent: String
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
        /// Set the content of a new song
        let content = ChordProDocument.getSongTemplateContent(settings: settings)
        self.standardDocumentContent = content
        self.newDocumentContent = content
    }
}

extension AppStateModel {

    /// The ID of the app state
    /// - Note: Used to load and save the settings in the cache
    enum AppStateID: String {
        case mainView
        case exportFolderView
        case chordsDatabaseView
    }
}

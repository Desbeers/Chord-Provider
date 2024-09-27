//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable app state for Chord Provider
@Observable @MainActor final class AppStateModel {
    /// The shared instance of the class
    static let shared = AppStateModel(id: "Main")
    /// The list with recent files
    var recentFiles: [URL] = []
    /// The content for a new document
    var newDocumentContent: String = ""
    /// The ID of the app state
    var id: String
    /// The application settings
    var settings: AppSettings {
        didSet {
            try? AppSettings.save(id: id, settings: settings)
        }
    }
    /// Init the class; get application settings
    init(id: String) {
        self.id = id
        self.settings = AppSettings.load(id: id)
    }
}

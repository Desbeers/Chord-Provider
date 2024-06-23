//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable app state for Chord Provider
@Observable final class AppState {
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

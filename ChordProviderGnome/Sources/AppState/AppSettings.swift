//
//  AppSettings.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

/// The settings for **Chord Provider**
struct AppSettings: Codable {
    /// Core settings
    var core = ChordProviderSettings()
    /// Application settings for all scenes
    var app = App()
    /// Editor settings
    var editor = Editor()
}

extension AppSettings {
    
    /// Make a URL identifiable
    struct URLElement: Identifiable, Codable {
        /// The ID of the URL
        var id = UUID()
        /// The URL
        var url: URL

    }
}

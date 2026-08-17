//
//  AppSettings.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

/// The settings for **Chord Provider**
struct AppSettings: Codable, Equatable {
    /// Application settings for all scenes
    var app = App()
    /// The theme settings
    var theme = Theme()
    /// The editor settings
    var editor = Editor()
}

//
//  AppSettings.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

/// The settings for **Chord Provider**
struct AppSettings: Codable, Equatable {
    /// Application settings for all scenes
    var app = App()
    /// The editor settings
    var editor = Editor()
    /// The core settings
    var core = ChordProviderSettings()
}

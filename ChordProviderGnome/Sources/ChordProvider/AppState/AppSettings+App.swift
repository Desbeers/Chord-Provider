//
//  AppSettings+App.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppSettings {

    /// Settings for all **Chord Provider** scenes
    struct App: Codable, Equatable {
        /// The songs folder
        var songsFolder: URL?
        /// The page layout
        var columnPaging: Bool = true
        /// The zoom factor
        var zoom: Double = 1
        /// The core settings
        var core = ChordProviderSettings()
    }
}

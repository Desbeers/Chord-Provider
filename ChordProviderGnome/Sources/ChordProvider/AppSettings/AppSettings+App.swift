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
        /// The page layout
        var columnPaging: Bool = true
        /// The zoom factor of the Render `View`
        var zoom: Double = 1
        /// Use sound for chord definitions
        var soundForChordDefinitions: Bool = false
    }
}

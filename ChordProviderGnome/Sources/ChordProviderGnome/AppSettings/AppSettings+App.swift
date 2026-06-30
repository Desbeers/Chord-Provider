//
//  AppSettings+App.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppSettings {

    /// Settings for all **Chord Provider** scenes
    struct App: Codable, Equatable {
        /// The current instrument ID
        var instrumentID: String = Instrument[.guitar].id
        /// All the instruments
        var instruments: [Instrument] = []
        /// The page layout
        var columnPaging: Bool = true
        /// Use sound for chord definitions
        var soundForChordDefinitions: Bool = false
        /// Debug stuff
        var debug: Bool = false
    }
}

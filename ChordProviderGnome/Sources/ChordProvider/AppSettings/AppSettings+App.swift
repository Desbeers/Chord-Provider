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
        /// The current instrument
        var instrument: Instrument = Instrument[.guitar]
        /// Custom instruments
        var customInstruments: [Instrument] = []
        /// The page layout
        var columnPaging: Bool = true
        /// Use sound for chord definitions
        var soundForChordDefinitions: Bool = false
        /// Debug stuff
        var debug: Bool = false
    }
}

//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// The observable app state for Chord Provider
@Observable
final class AppState {
    /// The Chord Provider settings
    var settings: ChordProviderSettings {
        didSet {
            ChordProviderSettings.save(settings: settings)
        }
    }
    /// Init the class; get Chord Provider settings
    init() {
        self.settings = ChordProviderSettings.load()
    }
}

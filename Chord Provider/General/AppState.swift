//
//  AppState.swift
//  Chord Provider (macOS)
//
//  © 2023 Nick Berendsen
//

import Foundation

/// The observable app state for Chord Provider
final class AppState: ObservableObject {
    /// The Chord Provider settings
    @Published var settings: ChordProviderSettings {
        didSet {
            ChordProviderSettings.save(settings: settings)
        }
    }
    /// Init the class; get Chord Provider settings
    init() {
        self.settings = ChordProviderSettings.load()
    }
}

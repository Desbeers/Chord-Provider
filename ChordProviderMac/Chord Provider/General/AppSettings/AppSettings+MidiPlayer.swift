//
//  AppSettings+MidiPlayer.swift
//  Chord Provider
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppSettings {

    /// Settings for playing chord diagrams with MIDI
    struct MidiPlayer: Equatable, Codable, Sendable {
        /// Show a button to play the chord with MIDI
        var showPlayButton: Bool = true
    }
}

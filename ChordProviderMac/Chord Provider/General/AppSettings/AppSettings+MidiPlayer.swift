//
//  AppSettings+MidiPlayer.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for playing chord diagrams with MIDI
    struct MidiPlayer: Equatable, Codable, Sendable {
        /// Show a button to play the chord with MIDI
        var showPlayButton: Bool = true
        /// The instrument to use for playing the chord with MIDI
        var instrument: Midi.Instrument = .acousticNylonGuitar
    }
}

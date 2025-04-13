//
//  AppSettings+Diagrams.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for displaying chord diagrams
    struct Diagram: Equatable, Codable, Sendable {
        /// Show the name in the chord shape
        var showName: Bool = true
        /// Show the notes of the chord
        var showNotes: Bool = false
        /// Show a button to play the chord with MIDI
        var showPlayButton: Bool = true
        /// Show the finger position on the diagram
        var showFingers: Bool = true
        /// Mirror the chord diagram for lefthanded users
        var mirrorDiagram: Bool = false
        /// The instrument to use for playing the chord with MIDI
        var midiInstrument: Midi.Instrument = .acousticNylonGuitar
    }
}

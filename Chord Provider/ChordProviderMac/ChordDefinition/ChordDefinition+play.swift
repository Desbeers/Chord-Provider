//
//  ChordDefinition+play.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import ChordProviderCore

extension ChordDefinition {

    /// Play a ``ChordDefinition`` with MIDI
    /// - Parameter instrument: The `instrument` to use
    func play(instrument: Midi.Instrument = .acousticNylonGuitar) {
        Task {
            await MidiPlayer.shared.playChord(notes: self.components.compactMap(\.midi), instrument: instrument)
        }
    }
}

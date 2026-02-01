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
    func play(instrument: MidiUtils.Instrument = .acousticNylonGuitar) {
        Task {
            let components = self.mirrored ? self.components.reversed() : self.components
            await MidiPlayer.shared.playChord(notes: components.compactMap(\.midi), instrument: instrument)
        }
    }
}

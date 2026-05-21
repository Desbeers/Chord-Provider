//
//  ChordProviderMIDI+playMetronome.swift
//  ChordProviderMIDI
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CFluidSynth

extension ChordProviderMIDI {

    // MARK: Metronome API

    /// Play the metronome
    public func playMetronome() async {
        /// Wait for the first accent
        while !transport.isAccent {
            try? await Task.sleep(for: .milliseconds(1))
        }
        playbackTasks.metronome = Task {
            await runMetronome()
        }
    }

    /// Stop the metronome
    public func stopMetronome() {
        playbackTasks.metronome?.cancel()
        playbackTasks.metronome = nil
    }

    // MARK: Metronome loop

    private func runMetronome() async {
        guard let synth else { return }
        /// Set the volume
        fluid_synth_cc(synth, metronome.channel, 11, 120)
        /// Set the note value
        var note: Int32 = 76
        /// Set the velocity value, higher for accent beats
        var velocity: Int32 = 120
        /// The tick counter
        var lastTick = transport.tick
        /// Loop the metronome until the task is canceled
        while !Task.isCancelled {
            lastTick = transport.tick
            /// Stop the previous note
            fluid_synth_noteoff(synth, metronome.channel, note)
            /// Set the note value
            note = transport.isAccent ? 76 : 81
            /// Set the velocity value, higher for accent beats
            velocity = transport.isAccent ? 120 : 90
            /// Play the note with an optional small delay
            try? await Task.sleep(for: .milliseconds(transport.isAccent ? 12 : 2))
            fluid_synth_noteon(synth, metronome.channel, note, velocity)
            while transport.tick == lastTick {
                try? await Task.sleep(for: .milliseconds(1))
            }
        }
    }
}

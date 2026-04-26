//
//  Utils+MidiPlayer+metronome.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth

extension Utils.MidiPlayer {

    // MARK: Metronome API

    /// Start the metronome
    func startMetronome() {
        if self.gridTask != nil {
            /// Restart the chords
            startChords()
        }
        stopMetronome()
        metronomeTask = Task { [weak self] in
            await self?.runMetronome()
        }
    }

    /// Stop the metronome
    func stopMetronome() {
        metronomeTask?.cancel()
        metronomeTask = nil
    }

    // MARK: Metronome loop

    private func runMetronome() async {
        guard let synth else { return }

        /// Set the instrument; defaults to electrical guitar
        fluid_synth_program_select(
            synth,
            metronomeChannel,
            soundFontID,
            0,
            0
        )

        fluid_synth_cc(synth, metronomeChannel, 11, 120)

        var pulse: Int = 0

        while !Task.isCancelled {

            let intervalNs = UInt64(
                60.0
                / (Double(metronomeBPM) * timeSignature.quarterNoteMultiplier)
                * 1_000_000_000
            )

            let isAccent = timeSignature.accentIndices.contains(pulse)

            let note: Int32 = isAccent ? 76 : 81
            let velocity: Int32 = isAccent ? 120 : 90

            fluid_synth_noteon(synth, metronomeChannel, note, velocity)

            try? await Task.sleep(nanoseconds: intervalNs)
            fluid_synth_noteoff(synth, metronomeChannel, note)

            pulse = (pulse + 1) % timeSignature.pulsesPerBar
        }
    }

    // MARK: Time Signature

    struct TimeSignature {

        let numerator: Int
        let denominator: Int

        /// Total pulses (eighth notes in /8 meters)
        let pulsesPerBar: Int

        /// Accent positions (pulse indices)
        let accentIndices: Set<Int>

        /// Quarter-note length multiplier for BPM
        let quarterNoteMultiplier: Double

        /// Default 4/4 time
        static let fourFour = TimeSignature(
            numerator: 4,
            denominator: 4,
            pulsesPerBar: 4,
            accentIndices: [0],
            quarterNoteMultiplier: 1.0
        )
    }
}

//
//  Utils+MidiPlayer+notes.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension Utils.MidiPlayer {

    func playChord(_ chord: ChordDefinition, preset: MidiUtils.Preset, strum: Chord.Strum?) async {
        var notes = chord.midiNotes
        if let strum = chord.strum, strum.rawValue.starts(with: "up") {
            notes.reverse()
        }
        await playNotes(notes, preset: preset, strum: chord.strum)
    }

    /// Play notes polyphonically
    /// - Parameters:
    ///   - notes: The notes to play
    ///   - preset: The MIDI preset
    func playNotes(_ notes: [Int], preset: MidiUtils.Preset, strum: Chord.Strum?) async {
        guard let synth, soundFontID >= 0 else { return }
        /// Cancel previous chord
        playToken = UUID()
        let myToken = playToken
        /// Get a MIDI channel
        let channel = allocateChannel()
        /// Get the program ID
        let program = Int32(preset.rawValue)
        /// Set the instrument
        fluid_synth_program_select(
            synth,
            channel,
            soundFontID,
            0,
            program
        )
        /// Reset the volume
        /// - Note: Because it might be decreased already during fade-out
        fluid_synth_cc(synth, channel, 11, startVolume)

        let totalStrumTime: Double = 0.5

        // MARK: Play the chord

        /// Strum notes
        for note in notes {
            fluid_synth_noteon(synth, channel, Int32(note), 110)
            //try? await Task.sleep(nanoseconds: 460_000_000 / UInt64(notes.count))
            try? await Task.sleep(for: .seconds(totalStrumTime / Double(notes.count)))
        }

        /// Sustain notes (cancellable)
        let sustainTime: UInt64 = 1_200_000_000
        let sustainStep: UInt64 = 100_000_000
        var waited: UInt64 = 0
        /// Sustain
        while waited < sustainTime {
            guard myToken == playToken else { break }
            try? await Task.sleep(nanoseconds: sustainStep)
            waited += sustainStep
        }

        /// Fade out notes (cancellable)
        let fadeSteps = 60
        let fadeInterval: UInt64 = 60_000_000
        /// Minimum gain (-34 dB)
        let minGain: Double = 0.02
        //// Fade curve (1.0 = pure log, >1 = faster drop)
        let curve: Double = 2.0
        /// Fade out
        for step in 0..<fadeSteps {
            guard myToken == playToken else { break }
            let time = Double(step) / Double(fadeSteps - 1)
            let gain = pow(minGain, pow(time, curve))
            let volume = Int32(Double(startVolume) * gain)

            fluid_synth_cc(synth, channel, 11, volume)
            try? await Task.sleep(nanoseconds: fadeInterval)
        }

        /// Release notes
        for note in notes {
            fluid_synth_noteoff(synth, channel, Int32(note))
        }
    }

    // MARK: Channel management

    /// AllocateChannel MIDI channel
    /// - Returns: A new MIDI channel
    private func allocateChannel() -> Int32 {
        let channel = nextChannel
        nextChannel = (nextChannel + 1) % maxChannels
        return channel
    }
}

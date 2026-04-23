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
        if let strum, Chord.Strum.upStrums.contains(strum) {
            notes.reverse()
        }
        await playNotes(notes, preset: preset, strum: strum)
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

        /// Get the playback settings for the strum
        /// - Note: If no strum is given, use the default settings
        let playbackSettings = strum?.playbackSettings ?? Chord.Strum.Playback()

        /// Reset the volume
        /// - Note: Because it might be decreased already during fade-out
        var volume = min(Int32(playbackSettings.velocity * 90), 120)
        if metronomeTask != nil {
            /// Reduce the notes volume a bit if the metronome is playing so you can here the metronome better
            volume -= 25
        }
        startVolume = volume
        fluid_synth_cc(synth, channel, 11, startVolume)

        // MARK: Play the chord

        /// Strum notes
        for note in notes {
            fluid_synth_noteon(synth, channel, Int32(note), 110)
            try? await Task.sleep(for: .seconds(playbackSettings.spread))
        }

        /// Sustain notes (cancellable)
        let sustainTime: Double = playbackSettings.duration
        let sustainStep: Double = 0.1

        var waited: Double = 0
        /// Sustain
        while waited < sustainTime {
            guard myToken == playToken else { break }
            try? await Task.sleep(for: .seconds(sustainStep))
            waited += sustainStep
        }

        /// Fade out notes (cancellable)
        let fadeSteps = 60
        let fadeInterval: Double = playbackSettings.fadeOut
        /// Minimum gain (-34 dB)
        let minGain: Double = 0.02
        //// Fade curve (1.0 = pure log, >1 = faster drop)
        let curve: Double = 4.0
        /// Fade out
        for step in 0..<fadeSteps {
            guard myToken == playToken else { break }
            let time = Double(step) / Double(fadeSteps - 1)
            let gain = pow(minGain, pow(time, curve))
            let volume = Int32(Double(startVolume) * gain)

            fluid_synth_cc(synth, channel, 11, volume)
            try? await Task.sleep(for: .seconds(fadeInterval))
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

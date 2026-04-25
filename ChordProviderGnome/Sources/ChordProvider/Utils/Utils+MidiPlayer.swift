//
//  Utils+MidiPlayer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth
import ChordProviderCore

extension Utils {

    /// Actor-based MIDI player
    actor MidiPlayer {

        // MARK: Shared instance

        /// The shared instance of the MIDI engine
        static let shared = MidiPlayer()

        // MARK: FluidSynth state

        /// The settings for FluentSynth
        var settings: OpaquePointer?
        /// The actual synth for FluentSynth
        var synth: OpaquePointer?
        /// The driver for FluentSynth
        var driver: OpaquePointer?
        /// The current SoundFont ID
        var soundFontID: Int32 = -1
        /// Initial volume
        var startVolume: Int32 = 120

        // MARK: MIDI channels

        /// The MIDI channel allocator
        var nextChannel: Int32 = 0
        /// The maximum MIDI channels
        let maxChannels: Int32 = 15

        // MARK: Metronome state

        /// Metronome task
        var metronomeTask: Task<Void, Never>?
        /// Metronome BPM
        var metronomeBPM: Int = 120
        /// Metronome channel (fixed)
        let metronomeChannel: Int32 = 15
        /// Time signature
        var timeSignature: TimeSignature = .fourFour

        /// Grid task
        var gridTask: Task<Void, Never>?
        var grids: [Song.Section.Line.GridCell]?
        var preset: MidiUtils.Preset = .acousticNylonGuitar
        nonisolated(unsafe) var currentChord: Int = -1

        // MARK: Play Token

        /// Current play token
        /// - Note: Used for cancelling a chord when we start a new one
        var playToken: UUID = UUID()

        nonisolated var getCurrentChord: Int {
            currentChord
        }

        // MARK: Init

        /// Init the MIDI engine
        init() {
            settings = new_fluid_settings()
            guard let settings else { return }

            /// Louder but safe volume
            fluid_settings_setnum(settings, "synth.gain", 0.9)

            fluid_settings_setint(settings, "audio.period-size", 512)
            fluid_settings_setint(settings, "audio.periods", 3)

            fluid_settings_setint(settings, "synth.polyphony", 64)

            fluid_settings_setint(settings, "synth.reverb.active", 0)
            fluid_settings_setint(settings, "synth.chorus.active", 0)

            /// Platform specific settings
#if os(macOS)
            fluid_settings_setstr(settings, "audio.driver", "coreaudio")
#elseif os(Linux)
            fluid_settings_setstr(settings, "audio.driver", "pipewire")
#endif
            synth = new_fluid_synth(settings)
            guard let synth else { return }

            /// Load the driver
            driver = new_fluid_audio_driver(settings, synth)

            /// Load the SoundFont
            /// - Note: Don't reset the channels (3th argument)
            ///         because its only a small SoundFont that does not have the standard channels
            if let sfPath = MidiUtils.soundFont {
                soundFontID = fluid_synth_sfload(synth, sfPath.path(), 1)
            } else {
                print("Sound font not found!")
            }

            // /// Apply A=432 Hz tuning
            // let tuningBank: Int32 = 0
            // let tuningProgram: Int32 = 0
            // /// Build full 128-note tuning table (in cents)
            // var tuning = [Double](repeating: 0.0, count: 128)

            // /// Detune relative to A=440
            // // let detune = -331.77
            // let detune: Double = 31.77

            // for index in 0..<128 {
            //     tuning[index] = Double(index) * 100.0 + detune
            // }
            // /// Define tuning (this creates or replaces it)
            // _ = tuning.withUnsafeBufferPointer { buffer in
            //     fluid_synth_activate_key_tuning(
            //         synth,
            //         tuningBank,
            //         tuningProgram,
            //         "A432 tuning",
            //         buffer.baseAddress,
            //         /// apply immediately
            //         1
            //     )
            // }
            // /// Activate tuning on all MIDI channels
            // for channel in 0..<16 {
            //     fluid_synth_activate_tuning(
            //         synth,
            //         Int32(channel),
            //         tuningBank,
            //         tuningProgram,
            //         /// apply immediately
            //         1
            //     )
            // }
        }
    }
}

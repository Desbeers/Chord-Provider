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
        let startVolume: Int32 = 120

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

        // MARK: Play Token

        /// Current play token
        /// - Note: Used for canceling a chord when we start a new one
        var playToken: UUID = UUID()

        // MARK: Init

        /// Init the MIDI engine
        init() {
            settings = new_fluid_settings()
            guard let settings else { return }

            /// Louder but safe volume
            fluid_settings_setnum(settings, "synth.gain", 0.9)

            /// Platform specific settings
#if os(macOS)
            fluid_settings_setstr(settings, "audio.driver", "coreaudio")
#elseif os(Linux)
            fluid_settings_setstr(settings, "audio.driver", "pipewire")
            fluid_settings_setint(settings, "audio.realtime-prio", 0)
#endif
            synth = new_fluid_synth(settings)
            guard let synth else { return }

            /// Natural sound
            /// - Note: Barely any difference
            fluid_synth_chorus_on(synth, 1, 1)
            fluid_synth_reverb_on(synth, 1, 1)

            /// Load the driver
            driver = new_fluid_audio_driver(settings, synth)

            /// Load the SoundFont
            /// - Note: Don't reset the channels (3th argument) because its only a small SoundFont that does not have the standard channels
            if let sfPath = MidiUtils.soundFont {
                soundFontID = fluid_synth_sfload(synth, sfPath.path(), 1)
            } else {
                print("Souns not found!")
            }
        }

        // MARK: Deinit

        deinit {
            if let driver { delete_fluid_audio_driver(driver) }
            if let synth { delete_fluid_synth(synth) }
            if let settings { delete_fluid_settings(settings) }
        }
    }
}

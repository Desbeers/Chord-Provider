//
//  Utils+MidiEngine.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth

extension Utils {

    /// Actor-based MIDI engine
    actor MidiEngine {

        // MARK: Shared instance

        /// The shared instance of the MIDI engine
        static let shared = MidiEngine()

        // MARK: FluidSynth state

        /// The settings for FluentSynth
        private var settings: OpaquePointer?
        /// The actual synth for FluentSynth
        private var synth: OpaquePointer?
        /// The driver for FluentSynth
        private var driver: OpaquePointer?
        /// The current SoundFont ID
        private var sfontID: Int32 = -1
        /// Initial volume
        private let startVolume: Int32 = 120

        // MARK: MIDI channels

        /// The MIDI channel allocator
        private var nextChannel: Int32 = 0
        /// The maximum MIDI channels
        private let maxChannels: Int32 = 16

        // MARK: Play Token

        /// Current play token
        /// - Note: Used for canceling a chord when we start a new one
        private var playToken: UInt64 = 0

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

            /// Load the drive
            driver = new_fluid_audio_driver(settings, synth)

            /// Load the SoundFont
            /// - Note: Don't reset the channels (3th argument) because its only a small SoundFont that does not have the standard channels
            if let sfPath = Bundle.module.path(forResource: "GuitarSoundFont", ofType: "sf2") {
                sfontID = fluid_synth_sfload(synth, sfPath, 0)
            }
        }

        // MARK: Public API

        /// Play notes polyphonically
        func playNotes(_ notes: [Int32], program: Int32 = 27) async {
            guard let synth, sfontID >= 0 else { return }
            /// Cancel previous chord
            playToken &+= 1
            let myToken = playToken
            /// Get a MIDI channel
            let channel = allocateChannel()

            /// Set the instrument; defaults to electrical guitar
            fluid_synth_program_select(
                synth,
                channel,
                sfontID,
                0,
                program
            )
            /// Reset the volume
            /// - Note: Because it might be decreased already during fade-out
            fluid_synth_cc(synth, channel, 11, startVolume)

            // MARK: Play the chord

            /// Strum notes
            for note in notes {
                fluid_synth_noteon(synth, channel, note, 110)
                try? await Task.sleep(nanoseconds: 80_000_000)
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

            /// Fade out notes  (cancellable)
            let fadeSteps = 60
            let fadeInterval: UInt64 = 60_000_000
            /// Minimum gain (-34 dB)
            let minGain: Double = 0.02
            //// Fade curve (1.0 = pure log, >1 = faster drop)
            let curve: Double = 2.0
            /// Fade out
            for step in 0..<fadeSteps {
                guard myToken == playToken else { break }
                let t = Double(step) / Double(fadeSteps - 1)
                //let gain = pow(minGain, t)          // exponential decay
                let gain = pow(minGain, pow(t, curve))
                let volume = Int32(Double(startVolume) * gain)

                fluid_synth_cc(synth, channel, 11, volume)
                try? await Task.sleep(nanoseconds: fadeInterval)
            }

            /// Release notes
            for note in notes {
                fluid_synth_noteoff(synth, channel, note)
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

        // MARK: Deinit

        deinit {
            if let driver { delete_fluid_audio_driver(driver) }
            if let synth { delete_fluid_synth(synth) }
            if let settings { delete_fluid_settings(settings) }
        }
    }
}

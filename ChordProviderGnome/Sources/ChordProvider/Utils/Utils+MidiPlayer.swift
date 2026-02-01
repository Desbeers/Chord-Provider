//
//  Utils+MidiPlayer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CFluidSynth

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
        var sfontID: Int32 = -1
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
            if let sfPath = Bundle.module.path(forResource: "GuitarSoundFont", ofType: "sf2") {
                sfontID = fluid_synth_sfload(synth, sfPath, 1)
            }
        }

        // MARK: Public API

//        /// Play notes polyphonically
//        func playNotes(_ notes: [Int32], program: Int) async {
//            guard let synth, sfontID >= 0 else { return }
//            /// Cancel previous chord
//            playToken = UUID()
//            let myToken = playToken
//            /// Get a MIDI channel
//            let channel = allocateChannel()
//
//            let program = Int32(program)
//
//            /// Set the instrument; defaults to electrical guitar
//            fluid_synth_program_select(
//                synth,
//                channel,
//                sfontID,
//                0,
//                program
//            )
//            /// Reset the volume
//            /// - Note: Because it might be decreased already during fade-out
//            fluid_synth_cc(synth, channel, 11, startVolume)
//
//            // MARK: Play the chord
//
//            /// Strum notes
//            for note in notes {
//                fluid_synth_noteon(synth, channel, note, 110)
//                try? await Task.sleep(nanoseconds: 80_000_000)
//            }
//
//            /// Sustain notes (cancellable)
//            let sustainTime: UInt64 = 1_200_000_000
//            let sustainStep: UInt64 = 100_000_000
//            var waited: UInt64 = 0
//            /// Sustain
//            while waited < sustainTime {
//                guard myToken == playToken else { break }
//                try? await Task.sleep(nanoseconds: sustainStep)
//                waited += sustainStep
//            }
//
//            /// Fade out notes  (cancellable)
//            let fadeSteps = 60
//            let fadeInterval: UInt64 = 60_000_000
//            /// Minimum gain (-34 dB)
//            let minGain: Double = 0.02
//            //// Fade curve (1.0 = pure log, >1 = faster drop)
//            let curve: Double = 2.0
//            /// Fade out
//            for step in 0..<fadeSteps {
//                guard myToken == playToken else { break }
//                let t = Double(step) / Double(fadeSteps - 1)
//                let gain = pow(minGain, pow(t, curve))
//                let volume = Int32(Double(startVolume) * gain)
//
//                fluid_synth_cc(synth, channel, 11, volume)
//                try? await Task.sleep(nanoseconds: fadeInterval)
//            }
//
//            /// Release notes
//            for note in notes {
//                fluid_synth_noteoff(synth, channel, note)
//            }
//        }
//
//        // MARK: Channel management
//
//        /// AllocateChannel MIDI channel
//        /// - Returns: A new MIDI channel
//        private func allocateChannel() -> Int32 {
//            let channel = nextChannel
//            nextChannel = (nextChannel + 1) % maxChannels
//            return channel
//        }

//        // MARK: Metronome API
//
//        /// Start the metronome
//        func startMetronome(bpm: Int) {
//            stopMetronome()
//            metronomeBPM = bpm
//
//            metronomeTask = Task { [weak self] in
//                await self?.runMetronome()
//            }
//        }
//
//        /// Stop the metronome
//        func stopMetronome() {
//            metronomeTask?.cancel()
//            metronomeTask = nil
//        }
//
//        /// Change the metronome BPM while running
//        func setMetronomeBPM(_ bpm: Int) {
//            metronomeBPM = max(20, min(bpm, 300)) // clamp to sane range
//        }
//
//        /// Set metronome meter: "4/4", "6/8", "7/8=2+2+3"
//        func setMetronomeMeter(_ meter: String) {
//
//            let mainParts = meter.split(separator: "=")
//            let signaturePart = mainParts[0]
//            let additivePart = mainParts.count > 1 ? mainParts[1] : nil
//
//            let sigParts = signaturePart.split(separator: "/")
//            guard
//                sigParts.count == 2,
//                let num = Int(sigParts[0]),
//                let den = Int(sigParts[1])
//            else { return }
//
//            // MARK: Additive meters (explicit grouping)
//            if
//                let additivePart,
//                let groups = parseAdditiveGroups(additivePart),
//                groups.reduce(0, +) == num
//            {
//                var accents: [Int] = []
//                var index = 0
//                for g in groups {
//                    accents.append(index)
//                    index += g
//                }
//
//                timeSignature = TimeSignature(
//                    numerator: num,
//                    denominator: den,
//                    pulsesPerBar: num,
//                    accentIndices: Set(accents),
//                    quarterNoteMultiplier: den == 8 ? 0.5 : 1.0
//                )
//                return
//            }
//
//            // MARK: Compound meters (6/8, 9/8, 12/8)
//            if den == 8, num % 3 == 0 {
//                let groups = Array(repeating: 3, count: num / 3)
//
//                var accents: [Int] = []
//                var index = 0
//                for g in groups {
//                    accents.append(index)
//                    index += g
//                }
//
//                timeSignature = TimeSignature(
//                    numerator: num,
//                    denominator: den,
//                    pulsesPerBar: num,
//                    accentIndices: Set(accents),
//                    quarterNoteMultiplier: 1.5
//                )
//                return
//            }
//
//            // MARK: Simple meters
//            timeSignature = TimeSignature(
//                numerator: num,
//                denominator: den,
//                pulsesPerBar: num,
//                accentIndices: [0],
//                quarterNoteMultiplier: 1.0
//            )
//        }
//
//
//        // MARK: Metronome loop
//
//        private func runMetronome() async {
//            guard let synth else { return }
//
//            /// Set the instrument; defaults to electrical guitar
//            fluid_synth_program_select(
//                synth,
//                metronomeChannel,
//                sfontID,
//                0,
//                0
//            )
//
//            var pulse: Int = 0
//
//            while !Task.isCancelled {
//
//                let intervalNs = UInt64(
//                    60.0
//                    / (Double(metronomeBPM) * timeSignature.quarterNoteMultiplier)
//                    * 1_000_000_000
//                )
//
//                let isAccent = timeSignature.accentIndices.contains(pulse)
//
//                let note: Int32 = isAccent ? 76 : 81
//                let velocity: Int32 = isAccent ? 120 : 90
//
//                fluid_synth_noteon(synth, metronomeChannel, note, velocity)
//
//                try? await Task.sleep(nanoseconds: intervalNs)
//                fluid_synth_noteoff(synth, metronomeChannel, note)
//
//                pulse = (pulse + 1) % timeSignature.pulsesPerBar
//            }
//        }
//
//        // MARK: Time Signature
//
//        struct TimeSignature {
//
//            let numerator: Int
//            let denominator: Int
//
//            /// Total pulses (eighth notes in /8 meters)
//            let pulsesPerBar: Int
//
//            /// Accent positions (pulse indices)
//            let accentIndices: Set<Int>
//
//            /// Quarter-note length multiplier for BPM
//            let quarterNoteMultiplier: Double
//
//            /// Default 4/4 time
//            static let fourFour = TimeSignature(
//                numerator: 4,
//                denominator: 4,
//                pulsesPerBar: 4,
//                accentIndices: [0],
//                quarterNoteMultiplier: 1.0
//            )
//        }
//
//        // MARK: Additive meter parsing
//
//        private func parseAdditiveGroups(_ string: Substring) -> [Int]? {
//            let groups = string.split(separator: "+").compactMap { Int($0) }
//            guard !groups.isEmpty else { return nil }
//            return groups
//        }

        // MARK: Deinit

        deinit {
            if let driver { delete_fluid_audio_driver(driver) }
            if let synth { delete_fluid_synth(synth) }
            if let settings { delete_fluid_settings(settings) }
        }
    }
}

//
//  Views+MidiPlayer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CFluidSynth

extension Views {

    /// A `View` that plays a Chord Definition
    struct MidiPlayer: View {
        /// Init the struct
        init(chord: ChordDefinition) {
            self.notes = chord.components.compactMap { value in
                if let midi = value.midi {
                    return Int32(midi)
                }
                return nil
            }
            self.chord = chord
        }
        /// The chord to play
        let chord: ChordDefinition
        /// The MIDI notes
        let notes: [Int32]
        /// The body of the `View`
        var view: Body {
            Button(chord.display, icon: .default(icon: .mediaPlaybackStart)) {
                playChord()
            }
            .style(.midiButton)
            .flat(true)
            .halign(.center)
            .padding(.top)
        }
        /// Play the chord with MIDI
        func playChord() {
            guard let sfUrl = Bundle.module.url(forResource: "GuitarSoundFont", withExtension: "sf2") else {
                return
            }
            Task.detached {
                let settings = new_fluid_settings()
                fluid_settings_setnum(settings, "synth.gain", 0.9)
#if os(macOS)
                fluid_settings_setstr(settings, "audio.driver", "coreaudio")
#elseif os(Linux)
                fluid_settings_setstr(settings, "audio.driver", "pipewire")
                fluid_settings_setint(settings, "audio.realtime-prio", 0)
#endif

                let synth = new_fluid_synth(settings)
                fluid_synth_chorus_on(synth, 1, 1)
                fluid_synth_reverb_on(synth, 1, 1)
                // max channel volume
                fluid_synth_cc(synth, 0, 7, 110)

                let driver = new_fluid_audio_driver(settings, synth)

                /// Load SoundFont
                let sfontID = fluid_synth_sfload(synth, sfUrl.path(), 0)

                /// Select Electric Guitar
                fluid_synth_program_select(
                    synth,
                    0,        /// channel
                    sfontID,  /// sfont_id
                    0,        /// bank
                    25        /// Electric Guitar
                )

                /// --- STRUM NOTES ---
                for note in notes {
                    fluid_synth_noteon(synth, 0, note, 110)
                    try? await Task.sleep(nanoseconds: 120_000_000)
                }

                /// --- SUSTAIN ---
                try? await Task.sleep(nanoseconds: 2_500_000_000)

                /// --- REAL FADE OUT via volume reduction ---
                let fadeSteps = 40
                let fadeInterval: UInt64 = 100_000_000  // 100ms per step
                let startVolume: Int32 = 110

                for step in 0..<fadeSteps {
                    let volume = Int32(Double(startVolume) * (1.0 - Double(step) / Double(fadeSteps)))
                    fluid_synth_cc(synth, 0, 7, volume)  // CC 7 = Master Volume
                    try? await Task.sleep(nanoseconds: fadeInterval)
                }

                /// Let reverb decay naturally
                try? await Task.sleep(nanoseconds: 400_000_000)
                /// --- RELEASE ALL NOTES AT ONCE ---
                for note in notes {
                    fluid_synth_noteoff(synth, 0, note)
                }

                /// Cleanup
                delete_fluid_audio_driver(driver)
                delete_fluid_synth(synth)
                delete_fluid_settings(settings)
            }
        }
    }
}

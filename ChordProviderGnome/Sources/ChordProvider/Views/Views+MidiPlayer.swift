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
                guard let sfUrl = Bundle.module.url(forResource: "GuitarSoundFont", withExtension: "sf2") else {
                    return
                }
                Task.detached {
                    let settings = new_fluid_settings()

                    #if os(macOS)
                    fluid_settings_setstr(settings, "audio.driver", "coreaudio")
                    #elseif os(Linux)
                    fluid_settings_setstr(settings, "audio.driver", "pipewire")
                    fluid_settings_setint(settings, "audio.realtime-prio", 0)
                    #endif

                    let synth = new_fluid_synth(settings)

                    fluid_synth_chorus_on(synth, 1, 1)
                    fluid_synth_reverb_on(synth, 1, 1)

                    let driver = new_fluid_audio_driver(settings, synth)

                    /// Load SoundFont
                    let sfontID = fluid_synth_sfload(synth, sfUrl.path(), 0)

                    // Select Electric Guitar
                    fluid_synth_program_select(
                        synth,
                        0,        // channel
                        sfontID,  // sfont_id
                        0,        // bank
                        25        // Electric Guitar
                    )

                    /// --- STRUM NOTES ---
                    for note in notes {
                        fluid_synth_noteon(synth, 0, note, 120)
                        try? await Task.sleep(nanoseconds: 80_000_000) // 50ms per string
                    }

                    /// --- SUSTAIN ---
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1s sustain

                    /// --- FADE OUT via staggered note-offs ---
                    for note in notes.reversed() { // reverse for descending strum
                        fluid_synth_noteoff(synth, 0, note)
                        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms per string fade
                    }

                    /// Cleanup
                    delete_fluid_audio_driver(driver)
                    delete_fluid_synth(synth)
                    delete_fluid_settings(settings)
                }
            }
            .style(.midiButton)
            .flat(true)
            .halign(.center)
        }
    }
}

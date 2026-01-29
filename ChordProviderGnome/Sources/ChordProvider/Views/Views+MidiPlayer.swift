//
//  Views+MidiPlayer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import CFluidSynth

extension Views {

    /// A `View` that plays MIDI
    struct MidiPlayer: View {
        var view: Body {
            Button("Play") {

                guard let sfUrl = Bundle.module.url(forResource: "GuitarSoundFont", withExtension: "sf2") else {
                    print("No such file")
                    return
                }

                let settings = new_fluid_settings()


                let synth = new_fluid_synth(settings)
                let driver = new_fluid_audio_driver(settings, synth)


                let sfontID = fluid_synth_sfload(
                    synth,
                    sfUrl.path(),
                    0
                )

                fluid_synth_program_select(
                    synth,
                    0,        // channel
                    sfontID,  // sfont_id (first loaded SoundFont)
                    0,        // bank
                    24        // Nylon Guitar
                )

                fluid_synth_noteon(synth, 0, 60, 100)
                sleep(1)
                fluid_synth_noteoff(synth, 0, 60)

                delete_fluid_audio_driver(driver)
                delete_fluid_synth(synth)
                delete_fluid_settings(settings)
            }
        }
    }
}

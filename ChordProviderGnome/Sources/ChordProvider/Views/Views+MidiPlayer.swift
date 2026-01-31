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
                Task {
                    await Utils.MidiEngine.shared.playNotes(notes)
                }
            }
            .style(.midiButton)
            .flat(true)
            .halign(.center)
            .padding(.top)
        }
    }
}

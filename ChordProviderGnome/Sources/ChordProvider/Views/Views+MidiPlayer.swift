//
//  Views+MidiPlayer.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// A `View` that plays a Chord Definition
    struct MidiPlayer: View {
        /// Init the `View`
        /// - Parameters:
        ///   - chord: The chord definition
        ///   - preset: The MIDI preset
        init(chord: ChordDefinition, preset: MidiUtils.Preset) {
            self.notes = chord.midiNotes
            self.chord = chord
            self.preset = preset
        }
        /// The chord to play
        let chord: ChordDefinition
        /// The MIDI notes
        let notes: [Int]
        /// The MIDI preset
        let preset: MidiUtils.Preset
        /// The body of the `View`
        var view: Body {
            Button(chord.display, icon: .default(icon: .mediaPlaybackStart)) {
                Task {
                    await Utils.MidiPlayer.shared.playNotes(notes, preset: preset)
                }
            }
            .insensitive(!chord.knownChord)
            .style(.midiButton)
            .flat(true)
            .halign(.center)
            .padding(.top)
        }
    }
}

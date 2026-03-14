//
//  Views+Chords.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for all the chords in a song
    struct Chords: View {
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to open the chord dialog
        @State private var chordDialog: Bool = false
        /// The selected chord
        // swiftlint:disable:next force_unwrapping
        @State private var selectedChord = ChordDefinition(
            instrument: Chord.Instrument(
                type: .guitar, 
                description: Chord.InstrumentType.guitar.description, 
                tuning: ["E2", "A2", "D3", "G3", "B3", "E4"]
            )
        )
        /// The body of the `View`
        var view: Body {
            ScrollView {
                ForEach(appState.editor.song.chords.filter { $0.kind.knownChord }) { chord in
                    MidiPlayer(chord: chord, preset: appState.settings.core.midiPreset)
                    Button("") {
                        selectedChord = chord
                        chordDialog.toggle()
                    }
                    .child {
                        ChordDiagram(chord: chord, coreSettings: appState.settings.core)
                    }
                    .style(.chordDiagramButton)
                    .flat(true)
                    .halign(.center)
                }
            }
            .frame(minWidth: 110)
            .dialog(
                visible: $chordDialog,
                width: 440,
                height: 440
            ) {
                Variations(
                    appState: $appState,
                    selectedChord: selectedChord,
                    chordDialog: $chordDialog
                )
            }
        }
    }
}

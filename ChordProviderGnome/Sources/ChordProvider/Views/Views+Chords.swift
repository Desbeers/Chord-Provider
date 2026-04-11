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
        @State private var selectedChord = ChordDefinition(
            instrument: Instrument[.guitar]
        )
        /// The body of the `View`
        var view: Body {
            ScrollView {
                ForEach(appState.editor.song.chords) { chord in
                    MidiPlayer(
                        chord: chord,
                        coreSettings: appState.editor.coreSettings
                    )
                    Button("") {
                        selectedChord = chord
                        chordDialog.toggle()
                    }
                    .child {
                        ChordDiagram(chord: chord, coreSettings: appState.editor.coreSettings)
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

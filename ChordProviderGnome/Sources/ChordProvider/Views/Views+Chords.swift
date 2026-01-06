//
//  Views+Chords.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for all the chords in a song
    struct Chords: View {
        /// The whole song
        let song: Song
        /// The state of the application
        @Binding var appState: AppState
        /// Bool to open the chord dialog
        @State private var chordDialog: Bool = false
        /// The selected chord
        // swiftlint:disable:next force_unwrapping
        @State private var selectedChord = ChordDefinition(name: "C", instrument: .guitar)!
        /// The body of the `View`
        var view: Body {
            ScrollView {
                ForEach(song.chords) { chord in
                    Button("") {
                        selectedChord = chord
                        chordDialog.toggle()
                    }
                    .child {
                        Text(chord.display)
                            .style(.chord)
                        Widgets.ChordDiagram(chord: chord, settings: appState.editor.song.settings)
                    }
                    .style(.chordButton)
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

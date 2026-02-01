//
//  Views+Chords+Variations.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Chords {

    /// The `View` for all the chord variations
    struct Variations: View {
        init(
            appState: Binding<AppState>,
            selectedChord: ChordDefinition,
            chordDialog: Binding<Bool>
        ) {
            self._appState = appState
            self._chordDialog = chordDialog
            var chords = Views.Chords.Variations.getChordDefinitions(chord: selectedChord)
            if selectedChord.kind == .customChord {
                chords = [selectedChord] + chords
            }
            self.chords = chords
            let current = chords.first { $0.define == selectedChord.define } ?? selectedChord
            self.selectedChord = current
            self._selectedVariationID = State(wrappedValue: current.id)
        }
        /// The state of the application
        @Binding var appState: AppState
        /// All the chords of the instrument
        let chords: [ChordDefinition]
        /// The selected chord
        let selectedChord: ChordDefinition
        /// The selected variation ID
        @State private var selectedVariationID: UUID
        /// Bool to open the chord dialog
        @Binding var chordDialog: Bool
        /// The body of the `View`
        var  view: Body {
            VStack {
                ScrollView {
                    FlowBox(chords, selection: $selectedVariationID) { chord in
                        VStack {
                            Views.MidiPlayer(chord: chord, midiInstrument: appState.settings.app.midiInstrument)
                            Views.ChordDiagram(chord: chord, width: 120, settings: appState.editor.song.settings)
                                .style(chord == selectedChord ? .selectedChord : .none)
                        }
                        .padding(4, .vertical)
                    }
                    .valign(.start)
                    .padding()
                }
                .vexpand()
                Separator()
                switch appState.settings.editor.showEditor {
                case true:
                    if
                        let chord = chords.first(where: { $0.id == selectedVariationID }),
                        !appState.editor.song.content.contains(chord.define) {
                        HStack {
                            Text("Add this chord definition to your song")
                                .hexpand()
                            Button("Add") {
                                chordDialog.toggle()
                                appState.editor.command = .appendText(text: "{define-\(appState.editor.song.settings.instrument.rawValue) \(chord.define)}")
                            }
                            .suggested()
                        }
                        .padding()
                    } else {
                        HStack {
                            Text("This chord is already defined in your song")
                                .hexpand()
                            Button("Close") {
                                chordDialog.toggle()
                            }
                            .suggested()
                        }
                        .padding()
                    }
                case false:
                    HStack {
                        Text("Open the editor to add another variation")
                            .hexpand()
                        Button("Open") {
                            appState.settings.editor.showEditor.toggle()
                        }
                        .suggested()
                    }
                    .padding()
                }
            }
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: selectedChord.quality.intervalsLabel,
                            title: "Chord Variations for '\(selectedChord.display)'"
                        )
                    }
            }
        }
        /// Get all chord definitions for the selected chord name
        /// - Returns: An array of chord definitions`
        private static func getChordDefinitions(chord: ChordDefinition) -> [ChordDefinition] {
            let allChords = ChordUtils.getAllChordsForInstrument(instrument: chord.instrument)
            return allChords
                .matching(root: chord.root)
                .matching(quality: chord.quality)
                .matching(slash: chord.slash)
        }
    }
}

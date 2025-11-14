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
        /// The settings of the application
        let settings: AppSettings
        /// Bool to open the chord dialog
        @State private var chordDialog: Bool = false
        /// The selected chord
        @State private var selectedChord: ChordDefinition? = nil
        /// The body of the `View`
        var view: Body {
            ScrollView {
                ForEach(song.chords) { chord in
                    Button("More") {
                        selectedChord = chord
                        chordDialog.toggle()
                    }
                    .child {
                        Text(chord.display)
                            .style(.chord)
                        Widgets.ChordDiagram(chord: chord, settings: settings)
                            .frame(minWidth: 100)
                    }
                    .style(.chordButton)
                    .flat(true)
                    .halign(.center)
                }
            }
            .frame(minWidth: 110)
            .dialog(
                visible: $chordDialog,
                title: "Chord Variations",
                width: 400,
                height: 400
            ) {
                ScrollView {
                    if let selectedChord {
                        VStack {
                            Text(selectedChord.display)
                                .style(.title)
                            ForEach(selectedChord.quality.intervals.intervals, horizontal: true) { interval in
                                Text(interval.description)
                                    .style(.subtitle)
                                    .padding(5, .horizontal)
                            }
                        }
                        .halign(.center)
                        FlowBox(getChordDefinitions(), selection: nil) { chord in
                            Widgets.ChordDiagram(chord: chord, settings: settings)
                                .frame(minWidth: 100)
                                .frame(maxWidth: 100)
                        }
                        .padding()
                    } else {
                        /// This should not happen
                        Text("No chord selected")
                    }
                }
                .topToolbar {
                    HeaderBar.empty()
                }
            }
        }

        /// Get all chord definitions for the selected chord name
        /// - Returns: An array of chord definitions`
        private func getChordDefinitions() -> [ChordDefinition] {
            guard let selectedChord else {
                return []
            }
            let allChords = ChordUtils.getAllChordsForInstrument(instrument: selectedChord.instrument)
            return allChords
                .matching(root: selectedChord.root)
                .matching(quality: selectedChord.quality)
                .matching(slash: selectedChord.slash)
        }
    }
}

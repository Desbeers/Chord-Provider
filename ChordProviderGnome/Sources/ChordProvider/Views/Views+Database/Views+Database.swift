//
//  Views+Database.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views {

    /// The `View` for showing the chord database
    struct Database: View {
        /// The `AdwaitaWindow`
        var window: AdwaitaWindow
        /// The application state
        @Binding var appState: AppState
        /// The database state
        @Binding var databaseState: DatabaseState
        /// The body of the `View`
        var view: Body {
            VStack {
                HStack {
                    ToggleGroup(
                        selection: $appState.settings.core.instrument.onSet {  _ in
                            if databaseState.databaseIsModified {
                                databaseState.exportDoneAction = .switchInstrument
                                databaseState.showChangedDatatabaseDialog = true
                            } else {
                                databaseState.allChords = getAllChordsForInstrument()
                                databaseState.filteredChords = getFilteredChords()
                                appState.editor.command = .updateSong
                            }
                        },
                        values: Chord.Instrument.allCases,
                        id: \.self,
                        label: \.description
                    )
                    .hexpand()
                    .padding(.trailing)
                    SearchEntry()
                        .text($databaseState.search.onSet { _ in
                                databaseState.filteredChords = getFilteredChords()
                            }
                        )
                        .placeholderText("Search")
                }
                .padding(.horizontal)
                VStack {
                    if databaseState.search.isEmpty {
                        ToggleGroup(
                            selection: $databaseState.chord.onSet { _ in
                                self.databaseState.filteredChords = getFilteredChords()
                            },
                            values: Chord.Root.naturalAndSharp.dropFirst().dropLast(),
                            id: \.self,
                            label: \.naturalAndSharpDisplay
                        )
                        .transition(.coverUpDown)
                        .padding([.leading, .trailing, .top])
                    }
                    ScrollView {
                        if databaseState.filteredChords.isEmpty {
                            StatusPage(
                                "No chords found",
                                icon: .default(icon: .systemSearch),
                                description: "Oops! We couldn't find any chords that match your search."
                            )
                        } else {
                            FlowBox(
                                databaseState.filteredChords,
                                id: \.self,
                                selection: $databaseState.definition
                            ) { chord in
                                if let chord {
                                    VStack {
                                        MidiPlayer(chord: chord, preset: appState.settings.core.midiPreset)
                                        ChordDiagram(chord: chord, width: 120, coreSettings: appState.settings.core)
                                    }
                                }
                            }
                            .valign(.start)
                            .padding()
                        }
                    }
                    .vexpand()
                }
                .padding()
                .card()
                HStack(spacing: 10) {
                    SwitchRow()
                        .title("Left-handed chords")
                        .active($appState.settings.core.diagram.mirror)
                    HStack {
                        DropDown(
                            selection: $appState.settings.core.midiPreset,
                            values: MidiUtils.Preset.allCases
                        )
                        Text(" ")
                            .hexpand()
                        if let definition = databaseState.definition {
                            Button("Edit \(definition.display)") {
                                databaseState.newChord = false
                                databaseState.showEditDefinitionDialog.toggle()
                            }
                            .padding(.trailing)
                        }
                        Button("New Definition") {
                            databaseState.newChord = true
                            databaseState.showEditDefinitionDialog.toggle()
                        }
                        .padding(.trailing)
                    }
                    .valign(.center)
                }
                .transition(.crossfade)
            }
            .topToolbar {
                HeaderBar { }
                end: {
                    Menu(icon: .default(icon: .openMenu)) {
                        MenuButton("Export Database") {
                            databaseState.exportDatabase.signal()
                        }
                    }
                }
                .headerBarTitle {
                    let subtitle = appState.settings.core.instrument.label
                    WindowTitle(
                        subtitle: "\(subtitle)\(databaseState.databaseIsModified ? " · modified" : "")",
                        title: "Chords Databse"
                    )
                }
            }
            .onAppear {
                Idle {
                    self.databaseState.allChords = getAllChordsForInstrument()
                    self.databaseState.filteredChords = getFilteredChords()
                }
            }
            /// Add the dialogs
            dialogs
        }

        /// Get all chords for an instrument
        /// - Returns: All the chords
        func getAllChordsForInstrument() -> [ChordDefinition] {
            ChordUtils.getAllChordsForInstrument(instrument: appState.settings.core.instrument)
        }

        /// Get all filtered chords
        /// - Returns: The filtered chords
        func getFilteredChords() -> [ChordDefinition] {
            self.databaseState.definition = nil
            var result = [ChordDefinition]()
            if databaseState.search.isEmpty {
                result = databaseState.allChords
                    .filter { $0.root == databaseState.chord }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            } else {
                result = databaseState.allChords
                    .filter { $0.name.starts(with: databaseState.search) }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            }
            return result
        }
    }
}

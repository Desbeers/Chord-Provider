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
        /// Bool if the sidebar is wide
        @State private var wide = true
        /// The body of the `View`x
        var view: Body {
            OverlaySplitView(visible: $databaseState.sidebarVisible) {
                ScrollView {
                    List(
                        appState.settings.app.instruments,
                        id: \.id,
                        selection: $databaseState.instrumentID.onSet {  _ in
                            if appState.currentInstrument.modified {
                                /// The instrument is modified; show a *Dialog*
                                databaseState.saveDoneAction = .switchInstrument
                                databaseState.showChangedDatatabaseDialog = true
                            } else {
                                /// Update to the new selected database
                                updateDatabase()
                            }
                        }
                    ) { element in
                        HStack {
                            VStack {
                                Text(element.kind.description)
                                    .style(.bold)
                                    .halign(.start)
                                Text(element.status)
                                    .style(.caption)
                                    .halign(.start)
                                Text(element.label)
                                    .halign(.start)
                                ForEach(element.tuning, horizontal: true) { tuning in
                                    Text("\(tuning.note)\(tuning.octave) ")
                                }
                            }
                            .hexpand()
                            if element.id == appState.settings.app.instrumentID {
                                VStack {
                                    Button(icon: .default(icon: .textEditor)) {
                                        databaseState.newDatabase = false
                                        databaseState.showNewDatabaseDialog = true
                                    }
                                    .flat()
                                    .tooltip("Edit the instrument")
                                    /// Build-in databases can not be edited
                                    .insensitive(element.bundle != nil)
                                    Button(icon: .default(icon: .editCopy)) {
                                        var instrument = appState.editor.coreSettings.instrument
                                        instrument.bundle = nil
                                        instrument.fileURL = nil
                                        instrument.label += " (copy)"
                                        instrument.modified = true
                                        /// Add the copy
                                        appState.settings.app.instruments.append(instrument)
                                        appState.settings.app.instruments.sort()
                                        /// Make it active
                                        appState.settings.app.instrumentID = instrument.id
                                    }
                                    .flat()
                                    .tooltip("Duplicate the instrument")
                                    .insensitive(appState.currentInstrument.modified)
                                }
                                .halign(.end)
                                .transition(.crossfade)
                            }
                        }
                        .hexpand()
                        .padding()
                    }
                    .sidebarStyle()
                }
                .hscrollbarPolicy(.never)
                .vexpand()
                .topToolbar {
                    HeaderBar.end {
                        menu
                    }
                    .headerBarTitle {
                        WindowTitle(subtitle: "", title: "Instruments")
                    }
                }
                Separator()
                    .padding(.horizontal)
                SwitchRow()
                    .title("Left-handed chords")
                    .active($appState.editor.coreSettings.diagram.mirror)
                    .padding(.bottom)
            } content: {
                VStack {
                    VStack {
                        if databaseState.search.isEmpty {
                            ToggleGroup(
                                selection: $databaseState.chord.onSet { _ in
                                    databaseState.getFilteredChords(allChords: appState.editor.coreSettings.chordDefinitions)
                                },
                                values: Chord.Root.naturalAndSharp,
                                id: \.self,
                                label: \.naturalAndSharpDisplay
                            )
                            .padding([.leading, .trailing, .top])
                        }
                        ScrollView {
                            if databaseState.filteredChords.isEmpty {
                                StatusPage(
                                    "No chords found",
                                    icon: .default(icon: .systemSearch),
                                    description: "Couldn't find any \(databaseState.search.isEmpty ? "\(databaseState.chord.naturalAndSharpDisplay) chords" : "chords that match your search")."
                                )
                                .transition(.crossfade)
                            } else {
                                FlowBox(
                                    databaseState.filteredChords,
                                    id: \.self,
                                    selection: $databaseState.definition
                                ) { chord in
                                    if let chord {
                                        VStack {
                                            MidiPlayer(chord: chord, coreSettings: appState.editor.coreSettings)
                                            ChordDiagram(chord: chord, width: 120, coreSettings: appState.editor.coreSettings)
                                        }
                                    }
                                }
                                .valign(.start)
                                .padding()
                                .transition(.crossfade)
                            }
                        }
                        .vexpand()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    .card()
                    HStack {
                        if appState.currentInstrument.bundle == nil {
                            Button("Save") {
                                if appState.currentInstrument.fileURL == nil {
                                    /// A new instrument
                                    databaseState.saveDoneAction = .useInstrument
                                    databaseState.exportDatabase.signal()
                                } else {
                                    /// Just save it
                                    databaseState.saveDoneAction = .doNothing
                                    save(instrument: appState.currentInstrument)
                                }
                            }
                            .padding(.leading)
                            .insensitive(!appState.currentInstrument.modified)
                            .transition(.crossfade)
                        }
                        Text(" ")
                            .hexpand()
                        if let definition = databaseState.definition {
                            HStack {
                                Button("Edit \(definition.display)") {
                                    databaseState.newChord = false
                                    databaseState.showDefinitionDialog.toggle()
                                }
                                .padding(.trailing)
                                Button("Delete \(definition.display)") {
                                    databaseState.showDeleteChordDialog = true
                                }
                                .padding(.trailing)
                            }
                        }
                        Button("New Definition") {
                            databaseState.newChord = true
                            databaseState.showDefinitionDialog.toggle()
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom)
                }
                .topToolbar {
                    HeaderBar {
                        Toggle(icon: .default(icon: .sidebarShow), isOn: $databaseState.sidebarVisible)
                            .tooltip("Toggle Sidebar")
                    }
                    end: {
                        if databaseState.sidebarVisible {
                            Text("").transition(.crossfade)
                        } else {
                            menu.transition(.crossfade)
                        }
                        SearchEntry()
                            .text($databaseState.search.onSet { _ in
                                    databaseState.getFilteredChords(allChords: appState.editor.coreSettings.chordDefinitions)
                                }
                            )
                            .placeholderText("Search")
                    }
                    .headerBarTitle {
                        if databaseState.sidebarVisible {
                            Text("")
                                .transition(.crossfade)
                        } else {
                            WindowTitle(
                                subtitle: appState.currentInstrument.description,
                                title: "Chords Database"
                            )
                            .transition(.crossfade)
                        }
                    }
                }
                .onAppear {
                    Idle {
                        databaseState.getFilteredChords(allChords: appState.editor.coreSettings.chordDefinitions)
                    }
                }
                .onUpdate {
                    Idle {
                        if !databaseState.showChangedDatatabaseDialog, databaseState.instrumentID != appState.settings.app.instrumentID {
                            /// The instrument is changed from the main `View`; update it
                            databaseState.instrumentID = appState.settings.app.instrumentID
                            databaseState.getFilteredChords(allChords: appState.editor.coreSettings.chordDefinitions)
                        }
                    }
                }
            }
            .collapsed(!wide)
            .breakpoint(minWidth: 1000, matches: $wide)
            /// Add the dialogs
            dialogs
        }
    }
}

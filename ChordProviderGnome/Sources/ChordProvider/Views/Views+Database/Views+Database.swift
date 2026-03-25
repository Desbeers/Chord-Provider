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

        func label(instrument: Instrument) -> String {
            var result: [String] = [instrument.bundle == nil ? instrument.fileURL?.lastPathComponent ?? "New" : "Build-in"]
            if appState.modifiedInstrument?.modified == instrument.modified {
                result.append("modified")
            }
            return result.joined(separator: " · ")
        }

        /// The body of the `View`
        var view: Body {
            OverlaySplitView(visible: $databaseState.sidebarVisible) {
                ScrollView {
                    List(
                        appState.chordInstruments,
                        selection: $appState.settings.app.instrument.onSet {  _ in
                            if appState.modifiedInstrument == nil {
                                updateDatabase()
                            } else {
                                databaseState.exportDoneAction = .switchInstrument
                                databaseState.showChangedDatatabaseDialog = true 
                            }
                        }
                    ) { element in
                        HStack {
                            VStack {
                                Text(element.kind.description)
                                    .style(.bold)
                                    .halign(.start)
                                Text(label(instrument: element))
                                    .style(.caption)
                                    .halign(.start)
                                Text(element.label)
                                    .halign(.start)
                                ForEach(element.tuning, horizontal: true) { tuning in
                                    Text("\(tuning.note)\(tuning.octave) ")
                                }
                            }
                            .hexpand()
                            if element == appState.settings.app.instrument {
                                VStack {
                                    Button(icon: .default(icon: .textEditor)) {
                                        databaseState.newDatabase = false
                                        databaseState.showNewDatabaseDialog = true
                                    }
                                    .flat()
                                    /// Build-in databases can not be edited
                                    .insensitive(appState.settings.app.instrument.bundle != nil)
                                    Button(icon: .default(icon: .editCopy)) {
                                        var instrument = appState.settings.core.instrument
                                        instrument.bundle = nil
                                        instrument.fileURL = nil
                                        instrument.label += " (copy)"
                                        instrument.modified = true
                                        /// Add the copy
                                        appState.modifiedInstrument = instrument
                                        appState.settings.app.instrument = instrument
                                    }
                                    .flat()
                                    .insensitive(appState.modifiedInstrument != nil)
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
                    .active($appState.settings.core.diagram.mirror)
                    .padding(.bottom)
            } content: {
                VStack {
                    VStack {
                        if databaseState.search.isEmpty {
                            ToggleGroup(
                                selection: $databaseState.chord.onSet { _ in
                                    databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
                                },
                                values: Chord.Root.naturalAndSharp.dropFirst().dropLast(),
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
                                            MidiPlayer(chord: chord, preset: appState.settings.core.midiPreset)
                                            ChordDiagram(chord: chord, width: 120, coreSettings: appState.settings.core)
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
                                    databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
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
                                subtitle: appState.settings.app.instrument.description,
                                title: "Chords Database"
                            )
                            .transition(.crossfade)
                        }
                    }
                }
                .onAppear {
                    Idle {
                        databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
                    }
                }
                .onUpdate {
                    Idle {
                        if databaseState.instrument != appState.settings.app.instrument {
                            /// The database is changed in the main window; update it
                            databaseState.instrument = appState.settings.app.instrument
                            databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
                        }
                    }
                }
            }
            .collapsed(!wide)
            .breakpoint(minWidth: 1000, matches: $wide)
            /// Add the dialogs
            dialogs
        }

        // The menu view
        var menu: AnyView {
            Menu(icon: .default(icon: .openMenu)) {
                // MenuButton("Save Database") {
                //     databaseState.newDatabase = true
                //     databaseState.showNewDatabaseDialog = true
                // }
                MenuButton("New Database") {
                    databaseState.newDatabase = true
                    databaseState.showNewDatabaseDialog = true
                }
                MenuButton("Import Database") {
                    databaseState.importDatabase.signal()
                }
                MenuButton("Export Database") {
                    databaseState.exportDoneAction = .doNothing
                    databaseState.exportDatabase.signal()
                }
            }
        }

        /// Update the database after a new instrument selection
        func updateDatabase() {
            databaseState.instrument = appState.settings.app.instrument
            appState.updateDatabase(instrument: appState.settings.app.instrument)
            databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
        }
    }
}

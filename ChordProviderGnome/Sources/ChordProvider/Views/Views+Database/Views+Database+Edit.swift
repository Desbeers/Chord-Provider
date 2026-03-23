//
//  Views+Database+Edit.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views.Database {

    /// A `View` to edit or make a new database
    struct Edit: View {

        init(appState: Binding<AppState>, databaseState: Binding<DatabaseState>, new: Bool) {
            self._appState = appState
            self._databaseState = databaseState
            var instrument = appState.wrappedValue.settings.app.instrument
            instrument.modified = true
            /// Fill-in the form, use the last instrument
            self._tunings = State(wrappedValue: instrument.tuning)
            self._instrumentType = State(wrappedValue: instrument.type)
            /// Make the decription empty for a new database
            self._description = State(wrappedValue: "\(new ? "" : instrument.label)")
            /// Make other stuff empty al well for a new database
            if new {
                instrument.bundle = nil
                instrument.fileURL = nil
            }
            self.instrument = instrument
            self.new = new
        }

        @State private var tunings: [Chord.Instrument.Tuning] = [.init(note: .c, value: 1)]
        @State private var instrumentType: Chord.InstrumentType = .guitar
        @State private var description: String = ""

        @Binding var appState: AppState
        @Binding var databaseState: DatabaseState
        let instrument: Chord.Instrument
        let new: Bool

        var result: Chord.Instrument {
            Chord.Instrument(
                type: instrumentType,
                label: description,
                tuning: tunings.map { "\($0.note.rawValue)\($0.octave)" },
                bundle: instrument.bundle,
                fileURL: instrument.fileURL,
                modified: true
            )
        }

        var view: Body {
            VStack {
                Form {
                    ToggleGroup(
                        selection: $instrumentType,
                        values: Chord.InstrumentType.allCases,
                        id: \.id,
                        label: \.description
                    )
                    .insensitive(!new)
                    EntryRow("Description", text: $description)
                    Button("Add String") {
                        let element = Chord.Instrument.Tuning(note: .e, value: 1)
                        tunings.append(element)
                    }
                    .insensitive(!new || tunings.count < 1 || tunings.count > 7)
                    .padding()
                    .halign(.center)
                    if !tunings.isEmpty {
                        ForEach(tunings, horizontal: true) { tune in
                            TuningPicker(tune: tune, tunings: $tunings, new: new)
                                .padding(2, .horizontal)
                        }
                        .halign(.center)
                        .padding()
                    }
                }
                .padding()
                Button(new ? "Create" : "Update") {
                    // let result = Chord.Instrument(
                    //     type: instrumentType,
                    //     label: description,
                    //     tuning: tunings.map { "\($0.note.rawValue)\($0.octave)" },
                    //     bundle: instrument.bundle,
                    //     fileURL: instrument.fileURL,
                    //     modified: true
                    // )
                    /// Remember as modified
                    //appState.settings.app.instrument = result
                    //appState.modifiedInstrument = result
                    if new {
                        /// Remember as modified
                        appState.modifiedInstrument = result
                        var database = ChordsDatabase()
                        database.instrument = result
                        database.definitions = []
                        appState.settings.app.instrument = database.instrument
                        appState.settings.core.database = database
                        appState.editor.command = .updateSong
                    } else {
                        /// Reimport the database
                        var database = ChordsDatabase()
                        database.instrument = result
                        database.definitions = appState.settings.core.database.definitions
                        do {
                            let export  = try ChordUtils.exportToJSON(database: database)
                            let database = try ChordsDatabase(json: export, fileURL: result.fileURL)
                            /// Remember as modified
                            appState.modifiedInstrument = result
                            appState.settings.app.instrument = result
                            appState.settings.core.database = database
                            appState.editor.command = .updateSong
                        } catch {
                            /// Nothing
                        }
                    }
                    databaseState.showNewDatabaseDialog = false
                }
                /// Disable when the form is too empty or not changed
                .insensitive(description.isEmpty || tunings.isEmpty || result == instrument)
                .halign(.center)
                .padding()
            }
            .topToolbar {
                HeaderBar.empty()
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: "\(instrumentType.description) · \(tunings.count) strings",
                            title: "\(new ? "New" : "Edit") Database"
                        )
                    }
            }
        }
    }
}

extension Views.Database.Edit {

    struct TuningPicker: View {

        init(tune: Chord.Instrument.Tuning, tunings: Binding<[Chord.Instrument.Tuning]>, new: Bool) {
            self.tune = tune
            self._tunings = tunings
            self._octave = State(wrappedValue: tune.octave)
            self.tuneID = tunings.wrappedValue.firstIndex(where: { $0.id == tune.id}) ?? 0
            self.new = new
        }

        let tune: Chord.Instrument.Tuning
        let tuneID: Int
        let new: Bool
        @Binding var tunings: [Chord.Instrument.Tuning]

        @State private var octave: Element.ID

        let elements = (1...12).map { Element(id: $0) }

        var view: Body {
            VStack {
                DropDown(
                    selection: $tunings[tuneID].note, 
                    values: Chord.Root.allCases.dropFirst().dropLast(),
                    id: \.id,
                    description: \.display
                )
                DropDown(
                    selection: $octave.onSet { value in tunings[tuneID].octave = value },
                    values: elements
                )
                Button(icon: .default(icon: .editDelete)) {
                    tunings.remove(at: tuneID)
                }
                .insensitive(!new || tunings.count == 1 || tunings.count > 8)
            }
            .modifyContent(VStack.self) { $0.linked() }
        }
    }

    struct Element: Identifiable, CustomStringConvertible, Equatable {
        var id: Int
        var description: String { String(id) }
    }
}
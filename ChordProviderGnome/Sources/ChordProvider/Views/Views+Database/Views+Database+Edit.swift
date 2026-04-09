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
        /// Init the form
        init(appState: Binding<AppState>, databaseState: Binding<DatabaseState>, new: Bool) {
            self._appState = appState
            self._databaseState = databaseState
            var instrument = appState.wrappedValue.currentInstrument
            instrument.modified = true
            /// Fill-in the form, use the last instrument
            self._tunings = State(wrappedValue: instrument.tuning)
            self._kind = State(wrappedValue: instrument.kind)
            /// Make the description empty for a new database
            self._description = State(wrappedValue: "\(new ? "" : instrument.label)")
            /// Make other stuff empty al well for a new database
            if new {
                instrument.bundle = nil
                instrument.fileURL = nil
            }
            self.instrument = instrument
            self.new = new
        }
        /// The tuning of the instrument
        @State private var tunings: [Instrument.Tuning] = []
        /// The kind of instrument
        @State private var kind: Instrument.Kind = .guitar
        /// The description of te instrument
        @State private var description: String = ""
        /// The state of the application
        @Binding var appState: AppState
        /// The state of the database
        @Binding var databaseState: DatabaseState
        /// The state of the instrument when opening the `View`
        /// - Note: To enable the button
        let instrument: Instrument
        /// Bool if the instrument is new
        let new: Bool
        /// The calculated instrument with the values from the form
        var result: Instrument {
            Instrument(
                kind: kind,
                label: description,
                tuning: tunings.map { "\($0.note.rawValue)\($0.octave)" },
                bundle: instrument.bundle,
                fileURL: instrument.fileURL,
                modified: true
            )
        }
        /// The body of the `View`
        var view: Body {
            VStack {
                Form {
                    ToggleGroup(
                        selection: $kind.onSet { kind in
                            /// Set the default tuning
                            tunings = Instrument[kind].tuning
                        },
                        values: Instrument.Kind.allCases,
                        id: \.id,
                        label: \.description
                    )
                    .padding()
                    .insensitive(!new)
                    EntryRow("Description", text: $description)
                    Button("Add String") {
                        let element = Instrument.Tuning(note: .e, octave: 1)
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
                    databaseState.definition = nil
                    var database = ChordsDatabase()
                    database.instrument = result
                    appState.settings.app.instrumentID = result.id
                    if new {
                        appState.settings.app.instruments.append(result)
                        appState.settings.app.instruments.sort()
                    } else {
                        /// Update the instrument
                        if let index = appState.settings.app.instruments.firstIndex(where: { $0.id == result.id }) {
                            appState.settings.app.instruments[index] = result
                        }
                        /// Set all chord definitions with the updated instrument
                        database.definitions = appState.editor.coreSettings.chordDefinitions.map { definition in
                            var copy = definition
                            copy.instrument = result
                            return copy
                        }
                        /// Filter the chords
                        databaseState.getFilteredChords(allChords: database.definitions)
                    }
                    /// Set the new or updated database
                    appState.setDatabase(database, main: false)
                    databaseState.showNewDatabaseDialog = false
                }
                /// Disable when the form is too empty or not changed
                .insensitive(description.isEmpty || tunings.isEmpty || result == instrument)
                .halign(.center)
                .padding()
            }
            .topToolbar {
                HeaderBar {
                    if !new {
                        Button("Remove") {
                            databaseState.showNewDatabaseDialog = false
                            appState.removeDatabase(instrument: appState.currentInstrument, main: true)
                        }
                        .destructive()
                        .padding(.trailing)
                    }
                }
                end: {}
                    .headerBarTitle {
                        WindowTitle(
                            subtitle: "\(kind.description) · \(tunings.count) strings",
                            title: "\(new ? "New" : "Edit") Database"
                        )
                    }
            }
        }
    }
}

extension Views.Database.Edit {

    struct TuningPicker: View {

        init(tune: Instrument.Tuning, tunings: Binding<[Instrument.Tuning]>, new: Bool) {
            self.tune = tune
            self._tunings = tunings
            self._octave = State(wrappedValue: tune.octave)
            self.tuneID = tunings.wrappedValue.firstIndex(where: { $0.id == tune.id}) ?? 0
            self.new = new
        }

        let tune: Instrument.Tuning
        let tuneID: Int
        let new: Bool
        @Binding var tunings: [Instrument.Tuning]

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
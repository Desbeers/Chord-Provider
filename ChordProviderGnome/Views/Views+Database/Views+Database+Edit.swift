//
//  Views+Database+Edit.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
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
            var currentInstrument = appState.wrappedValue.currentInstrument
            currentInstrument.modified = true
            /// Fill-in the form, use the last currentInstrument
            self._tunings = State(wrappedValue: currentInstrument.tuning)
            self._kind = State(wrappedValue: currentInstrument.kind)
            /// Make the description empty for a new database
            self._description = State(wrappedValue: "\(new ? "" : currentInstrument.label)")
            /// Make other stuff empty al well for a new database
            if new {
                currentInstrument.bundle = nil
                currentInstrument.fileURL = nil
            }
            self.instrument = currentInstrument
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
                        ForEach(tunings) { tune in
                            TuningPicker(tune: tune, tunings: $tunings, new: new)
                                .padding(2, .horizontal)
                        }
                        .orientation(.horizontal)
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
                        databaseState.setFilteredChords(allChords: database.definitions)
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
                end: {
                    // No content
                }
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

    /// The `View` for a tuning picker
    struct TuningPicker: View {

        /// Init the tuning picker `View`
        /// - Parameters:
        ///   - tune: The current tuning
        ///   - tunings: The tuning values
        ///   - new: Bool if the tuning is new
        init(tune: Instrument.Tuning, tunings: Binding<[Instrument.Tuning]>, new: Bool) {
            self.tune = tune
            self._tunings = tunings
            self._octave = State(wrappedValue: tune.octave)
            self.tuneID = tunings.wrappedValue.firstIndex { $0.id == tune.id } ?? 0
            self.new = new
        }
        /// The tuning
        let tune: Instrument.Tuning
        /// The ID of the tuning
        let tuneID: Int
        /// Bool if the tuning is new
        let new: Bool
        /// The tuning values
        @Binding var tunings: [Instrument.Tuning]
        /// The octave
        @State private var octave: Element.ID
        /// The tuning elements
        let elements = (1...12).map { Element(id: $0) }
        /// The body of the `View`
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

    /// A tuning element
    struct Element: Identifiable, CustomStringConvertible, Equatable {

        /// The ID of the element
        var id: Int
        /// CustomStringConvertible protocol
        var description: String { String(id) }
    }
}

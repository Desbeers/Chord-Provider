//
//  Views+Database+DefineChord.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views.Database {

    /// The `View` to edit or add a chord definition
    struct DefineChord: View {
        init(appState: Binding<AppState>, databaseState: Binding<DatabaseState>) {
            self.newChord = databaseState.wrappedValue.newChord
            if !newChord, let definition = databaseState.definition.wrappedValue {
                self._definition = State(wrappedValue: definition)
            } else {
                /// Create a new definition with the current root
                var definition = ChordDefinition(instrument: appState.wrappedValue.settings.core.instrument)
                definition.root = databaseState.wrappedValue.chord
                self._definition = State(wrappedValue: definition)
            }
            self._databaseState = databaseState
            self._appState = appState
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The state of the database
        @Binding var databaseState: DatabaseState
        /// Bool if the chord definition is new
        let newChord: Bool
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// The bdy of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Views.DefineChord(
                    definition: $definition,
                    newChord: newChord,
                    appSettings: appState.settings
                )
                Separator()
                HStack {
                    SwitchRow()
                        .title("Play notes")
                        .active($appState.settings.app.soundForChordDefinitions)
                    HStack(spacing: 10) {
                        Text(" ")
                            .hexpand()
                        Button("Cancel") {
                            databaseState.showEditDefinitionDialog = false
                        }
                        Button("\(newChord ? "Add" : "Update") Definition") {
                            /// Set the instrument as modified
                            var modifiedInstrument = appState.settings.app.instrument
                            modifiedInstrument.modified = true
                            appState.modifiedInstrument = modifiedInstrument
                            appState.settings.app.instrument = modifiedInstrument
                            switch newChord {
                                case true:
                                    appState.settings.core.chordDefinitions.append(definition)
                                case false:
                                    if let index = appState.settings.core.chordDefinitions.firstIndex(where: { $0.id == definition.id } ) {
                                        appState.settings.core.chordDefinitions[index] = definition
                                    }
                            }
                            databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
                            databaseState.chord = definition.root
                            databaseState.definition = definition
                            databaseState.showEditDefinitionDialog = false
                            appState.editor.command = .updateSong
                        }
                        .suggested()
                        .padding(.trailing)
                        .insensitive(databaseState.definition == definition)
                    }
                    .valign(.center)
                }
            }
        }
    }
}
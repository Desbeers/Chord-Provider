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
        init(databaseState: Binding<DatabaseState>, appSettings: Binding<AppSettings>) {
            if let definition = databaseState.definition.wrappedValue {
                self._definition = State(wrappedValue: definition)
            } else {
                let definition = ChordDefinition(name: "C", instrument: databaseState.wrappedValue.instrument)!
                self._definition = State(wrappedValue: definition)
            }
            self._databaseState = databaseState
            self._appSettings = appSettings
            self.newChord = databaseState.wrappedValue.newChord
        }
        /// The state of the database
        @Binding var databaseState: DatabaseState
        /// The app settings
        @Binding var appSettings: AppSettings
        /// Bool if the chord definition is new
        let newChord: Bool
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// The bdy of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Views.DefineChord(definition: $definition, newChord: newChord, appSettings: appSettings)
                Separator()
                HStack {
                    SwitchRow()
                        .title("Play notes")
                        .active($appSettings.app.soundForChordDefinitions)
                    HStack(spacing: 10) {
                        Text(" ")
                            .hexpand()
                        Button("Cancel") {
                            databaseState.showEditDefinitionDialog = false
                        }
                        Button("\(newChord ? "Add" : "Update") Definition") {
                            switch newChord {
                                case true:
                                    databaseState.chord = definition.root
                                    databaseState.allChords.append(definition)
                                    databaseState.filteredChords.append(definition)
                                    databaseState.filteredChords.sort( 
                                        using: [
                                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                                        ]
                                    )
                                case false:
                                    if let index = databaseState.allChords.firstIndex(where: { $0.id == definition.id } ) {
                                        databaseState.allChords[index] = definition
                                    }
                                    if let index = databaseState.filteredChords.firstIndex(where: { $0.id == definition.id } ) {
                                        databaseState.filteredChords[index] = definition
                                    }
                            }
                            databaseState.databaseIsModified = true
                            databaseState.definition = definition
                            databaseState.showEditDefinitionDialog = false
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
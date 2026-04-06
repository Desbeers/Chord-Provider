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
            /// Create a new definition with the current root
            var definition = ChordDefinition(instrument: appState.wrappedValue.editor.coreSettings.instrument)
            definition.root = databaseState.wrappedValue.chord
            self.newChord = databaseState.wrappedValue.newChord
            if !newChord, let currentDefinition = databaseState.definition.wrappedValue {
                definition = currentDefinition
            }
            /// Try to find the optional flat version
            self.flatChordID = definition.findFlatFromSharp(chords: appState.wrappedValue.editor.coreSettings.chordDefinitions)?.id
            self._definition = State(wrappedValue: definition)
            self._databaseState = databaseState
            self._appState = appState
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The state of the database
        @Binding var databaseState: DatabaseState
        /// Bool if the chord definition is new
        let newChord: Bool
        /// ID of the optional flats version
        let flatChordID: UUID?
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// Help label
        var helpLabel: String? {
            if definition.root.accidental != .natural {
                 return "When \(newChord ? "adding" : "updating") <b>\(definition.display)</b>, <b>\(definition.displayFlatForSharp)</b> will be \(newChord ? "added" : "updated") as well"
            }
            return nil
        }
        /// The bdy of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Views.DefineChord(
                    definition: $definition,
                    newChord: newChord,
                    mergeSharpAndFlat: true,
                    coreSettings: appState.editor.coreSettings,
                    appSettings: appState.settings
                )
                Separator()
                HStack {
                    SwitchRow()
                        .title("Play notes")
                        .active($appState.settings.app.soundForChordDefinitions)
                    HStack(spacing: 10) {
                        Text("")
                            .hexpand()
                        if let helpLabel {
                            Text(helpLabel)
                            .useMarkup()
                            .caption()
                            .padding()
                        }
                        Button("Cancel") {
                            databaseState.showDefinitionDialog = false
                        }
                        Button("\(newChord ? "Add" : "Update") Definition") {
                            /// Mark the instrument as modified
                            appState.markCurrentInstrumentAsModified()
                            /// Update the database
                            var chords = appState.editor.coreSettings.chordDefinitions
                            /// Remove the current definition
                            if let index = chords.firstIndex(where: { $0.id == definition.id }) {
                                chords.remove(at: index)
                            }
                            /// Remove the optional flat version
                            if let flatChordID, let index = chords.firstIndex(where: { $0.id == flatChordID }) {
                                chords.remove(at: index)
                            }
                            /// Add the definition                    
                            chords.append(definition)
                            if definition.root.accidental == .sharp {
                                /// Add a flat version
                                var flat = definition
                                flat.root = definition.root.swapSharpForFlat
                                flat.id = UUID()
                                chords.append(flat)
                            }
                            /// Sort the chords
                            chords.sort()
                            Idle {
                                appState.editor.coreSettings.chordDefinitions = chords
                                databaseState.getFilteredChords(allChords: chords)
                                databaseState.chord = definition.root
                                databaseState.definition = definition
                                databaseState.showDefinitionDialog = false
                                appState.editor.command = .updateSong
                            }
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

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
            /// Try to find the optional shadow version
            self.shadowChord = definition.enharmonicEquivalent(in: appState.wrappedValue.editor.coreSettings.chordDefinitions)
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
        /// The optional shadow version
        let shadowChord: ChordDefinition?
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// Help label
        var helpLabel: String? {
            //if definition.root.accidental != .natural {
            if let shadowChord {
                 return "When \(newChord ? "adding" : "updating") <b>\(definition.display)</b>, <b>\(shadowChord.display)</b> will be \(newChord ? "added" : "updated") as well"
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
                            /// Give a new chord a new ID
                            definition.id = newChord ? UUID() : definition.id
                            /// Mark the instrument as modified
                            appState.markCurrentInstrumentAsModified()
                            /// Update the database
                            var chords = appState.editor.coreSettings.chordDefinitions
                            /// Remove the current definition
                            if let index = chords.firstIndex(where: { $0.id == definition.id }) {
                                chords.remove(at: index)
                            }
                            /// Remove the optional shadow version
                            if let shadowChord, let index = chords.firstIndex(where: { $0.id == shadowChord.id }) {
                                chords.remove(at: index)
                            }
                            /// Add the definition                    
                            chords.append(definition)
                            if definition.root.accidental != .natural, let root = definition.root.swapSharpAndFlat {
                                /// Add a shadow version
                                var shadow = definition
                                shadow.root = root
                                shadow.id = UUID()
                                chords.append(shadow)
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

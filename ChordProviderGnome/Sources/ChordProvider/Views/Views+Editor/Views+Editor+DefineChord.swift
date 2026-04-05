//
//  Views+Editor+DefineChord.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import CAdw

extension Views.Editor {

    /// The `View` to edit or add a chord definition
    struct DefineChord: View {
        init(appState: Binding<AppState>) {
            let instrument = appState.wrappedValue.settings.core.instrument
            var newChord = true
            var definition = ChordDefinition(
                instrument: instrument,
                chords: appState.wrappedValue.settings.core.chordDefinitions
            )
            /// Check if we are called as *edit* the definition instead of a new one
            if let currentDefinition = try? ChordDefinition(
                definition: appState.editor.currentLine.plain.wrappedValue ?? "",
                kind: .customChord,
                instrument: instrument
            ) {
                definition = currentDefinition
                newChord = false
            }
            self._appState = appState
            self._definition = State(wrappedValue: definition)
            self.newChord = newChord
        }
        /// The state of the application
        @Binding var appState: AppState
        /// Bool if the chord definition is new
        let newChord: Bool
        /// The state of the chord definition
        @State private var definition: ChordDefinition
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 10) {
                Views.DefineChord(
                    definition: $definition, 
                    newChord: newChord,
                    mergeSharpAndFlat: false,
                    appSettings: appState.settings
                )
                Separator()
                HStack {
                    SwitchRow()
                        .title("Play notes")
                        .active($appState.settings.app.soundForChordDefinitions)
                    HStack(spacing: 10) {
                        DropDown(
                            selection: $appState.settings.core.midiPreset,
                            values: MidiUtils.Preset.allCases
                        )
                        .insensitive(!appState.settings.app.soundForChordDefinitions)
                        Text(" ")
                            .hexpand()
                        Button("Cancel") {
                            appState.editor.showEditDirectiveDialog = false
                        }
                        Button("\(newChord ? "Add" : "Update") Definition") {
                            if newChord {
                                appState.editor.command = .appendText(text: definition.define)
                            } else {
                                appState.editor.command = .replaceLineText(text: definition.define)
                            }
                            appState.editor.showEditDirectiveDialog = false
                        }
                        .suggested()
                        .padding(.trailing)
                    }
                    .valign(.center)
                }
            }
        }
    }
}

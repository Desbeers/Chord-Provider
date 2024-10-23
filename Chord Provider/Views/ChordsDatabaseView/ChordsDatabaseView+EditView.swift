//
//  ChordsDatabaseView+EditView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordsDatabaseView {

    /// SwiftUI `View` to edit the database
    @MainActor struct EditView: View {
        /// The chord we want to edit or the chord as starting point to add
        let chord: ChordDefinition
        /// The optional flat chord when editing or adding a sharp chord
        @State var flatChord: ChordDefinition?
        /// The observable state of the scene
        @Environment(SceneStateModel.self) private var sceneState
        /// The observable state of the chords database
        @Environment(ChordsDatabaseStateModel.self) private var chordDatabaseState
        /// The body of the `View`
        var body: some View {
            VStack {
                CreateChordView(showAllOption: false, hideFlats: true, sceneState: sceneState)
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)
                buttons
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(.ultraThinMaterial)
            }
            .task(id: chord) {
                flatChord = chordDatabaseState.allChords.first {
                    $0.root == chord.root.swapSharpForFlat &&
                    $0.frets == chord.frets &&
                    $0.baseFret == chord.baseFret
                }
            }
        }
        /// The editor bottons
        var buttons: some View {
            VStack {
                if let flatChord {
                    Label("**\(flatChord.display)** will be edited as well", systemImage: "info.circle")
                } else if sceneState.definition.root.accidental == .sharp {
                    Label("**\(sceneState.definition.displayFlatForSharp)** will be added as well", systemImage: "info.circle")
                }
                HStack {
                    Button {
                        chordDatabaseState.navigationStack = []
                    } label: {
                        Text("Cancel")
                    }
                    Button {
                        var chord = sceneState.definition
                        /// Set the status
                        chord.status = .standardChord
                        /// Add or edit the chord
                        switch sceneState.definition.status {
                        case .addDefinition:
                            /// Give it an unique ID
                            chord.id = UUID()
                            /// Add it to the database
                            chordDatabaseState.allChords.append(chord)
                            /// Add a flat version if the definition is sharp
                            if sceneState.definition.root.accidental == .sharp {
                                /// Give it another unique ID
                                chord.id = UUID()
                                /// Swap sharp for flat
                                chord.root = chord.root.swapSharpForFlat
                                /// Add it to the database
                                chordDatabaseState.allChords.append(chord)
                            }
                        case .editDefinition:
                            if let chordIndex = chordDatabaseState.allChords.firstIndex(where: { $0.id == chord.id }) {
                                /// Update the database
                                chordDatabaseState.allChords[chordIndex] = chord
                            }
                            if let flatChord, let flatChordIndex = chordDatabaseState.allChords.firstIndex(where: { $0.id == flatChord.id }) {
                                /// Get it the correct ID of the flat chord
                                chord.id = flatChord.id
                                /// Swap sharp for flat
                                chord.root = chord.root.swapSharpForFlat
                                /// Update the database
                                chordDatabaseState.allChords[flatChordIndex] = chord
                            }
                        default:
                            break
                        }
                        /// Return to the root view
                        chordDatabaseState.navigationStack = []
                    } label: {
                        Text(sceneState.definition.status.rawValue)
                    }
                    .keyboardShortcut(.return)
                    .disabled(chord == sceneState.definition)
                }
            }
        }
    }
}

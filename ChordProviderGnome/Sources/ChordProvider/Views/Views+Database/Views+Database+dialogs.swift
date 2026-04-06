//
//  Views+Database+dialogs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Database {
    /// The dialogs for the *Database View*
    var dialogs: AnyView {
        /// Attachment point
        exportModifiedDialog

            // MARK: Error Dialog

            /// The **Alert dialog** for an error
            .alertDialog(
                visible: $appState.scene.showDatabaseErrorDialog,
                heading: appState.scene.error?.localizedDescription ?? "Error",
                id: "error-dialog",
                /// - Note: I use `extraChild` instead of `body` so I can use markup
                extraChild: {
                    Views.ErrorMessage(error: appState.scene.error)
                }
            )
            .response("OK", role: .default) {
                /// Do nothing
            }

            // MARK: Definition Dialog

            /// The **dialog** to add or edit a definition
            .dialog(
                visible: $databaseState.showDefinitionDialog
            ) {
                DefineChord(
                    appState: $appState,
                    databaseState: $databaseState
                )
            }
            .dialog(
                visible: $databaseState.showNewDatabaseDialog,
                width: 520,
                height: 400
            ) {
                Edit(appState: $appState, databaseState: $databaseState, new: databaseState.newDatabase)
            }
            /// Import database dialog
            .fileImporter(
                open: databaseState.importDatabase,
                extensions: ["json"]
            ) { fileURL in
                appState.importDatabase(url: fileURL, main: false)
            }
            /// Export database dialog
            .fileExporter(
                open: databaseState.exportDatabase,
                initialName: "\(appState.editor.coreSettings.instrument.label).json",
                onSave: { fileURL in
                    var instrument = appState.currentInstrument
                    /// An export will never be a build-in
                    instrument.bundle = nil
                    instrument.fileURL = fileURL
                    save(instrument: instrument)
                },
                onClose: {
                    /// Export canceled; revert
                    updateDatabase()
                }
            )
            /// The **Alert dialog** when deleting a chord
            .alertDialog(
                visible: $databaseState.showDeleteChordDialog,
                heading: "Delete Chord?",
                id: "delete-chord-dialog",
                /// - Note: Use `extraChild` instead of `body` so I can use markup
                extraChild: {
                    VStack {
                        Text("Are you sure you want to delete <b>\(databaseState.definition?.display ?? "")</b>?")
                            .useMarkup()
                            .style(.subtitle)
                            .padding(.bottom)
                        Text("This can not be undone.")
                    }
                    /// - Note: Dirty trick to show all three buttons vertical
                    .frame(minWidth: 380)
                }
            )
            .response("Cancel", role: .close) {
                /// Nothing to do
            }
            .response("Delete", appearance: .destructive, role: .default) {
                if let definition = databaseState.definition {
                    /// Mark the instrument as modified
                    //appState.markInstrumentAsModified()
                    var chords = appState.editor.coreSettings.chordDefinitions
                    if let index = chords.firstIndex(where: { $0.id == definition.id }) {
                        chords.remove(at: index)
                    }//
                    if let flat = definition.findFlatFromSharp(chords: chords),
                        let index = chords.firstIndex(where: { $0.id == flat.id }) {
                        chords.remove(at: index)
                    }
                    Idle {
                        appState.editor.coreSettings.chordDefinitions = chords
                        databaseState.getFilteredChords(allChords: chords)
                        appState.editor.command = .updateSong
                    }
                }
            }
    }
}
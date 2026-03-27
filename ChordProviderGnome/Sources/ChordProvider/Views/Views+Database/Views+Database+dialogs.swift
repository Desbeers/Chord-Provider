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
        Views.Empty()
            .dialog(
                visible: $databaseState.showEditDefinitionDialog
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
            .fileExporter(
                open: databaseState.exportDatabase,
                initialName: "\(appState.settings.core.instrument.label).json",
                onSave: { fileURL in
                    do {
                        let database = ChordsDatabase(
                            instrument: appState.settings.core.instrument,
                            definitions: appState.settings.core.chordDefinitions
                        )
                        let export  = try ChordUtils.exportToJSON(database: database)
                        try export.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                        appState.modifiedInstrument = nil
                        switch databaseState.exportDoneAction {
                        case .closeWindow:
                            window.close()
                        default:
                            break
                        }
                    } catch {
                        appState.scene.error  = .databaseExportError(error: error.localizedDescription)   
                    }
                },
                onClose: {
                    /// Export canceled; revert
                    appState.modifiedInstrument = nil
                    updateDatabase()
                }
            )
            /// The **Alert dialog** when a database is changed but not yet saved
            .alertDialog(
                visible: $databaseState.showChangedDatatabaseDialog,
                heading: "\(appState.modifiedInstrument?.fileURL == nil ? "Export" : "Save") Changes?",
                id: "dirty-database-dialog",
                /// - Note: Use `extraChild` instead of `body` so I can use markup
                extraChild: {
                    let instrument = appState.modifiedInstrument ?? Instrument[.guitar]
                    VStack {
                        Text("The <b>\(instrument.kind), \(instrument.label)</b> database is modified.")
                            .useMarkup()
                            .style(.subtitle)
                            .padding(.bottom)
                        Text("Changes which are not saved will be permanently lost.")
                    }
                    /// - Note: Dirty trick to show all three buttons vertical
                    .frame(minWidth: 380)
                }
            )
            .response("Cancel", role: .close) {
                Idle {
                    if let instrument = appState.modifiedInstrument {
                        appState.settings.app.instrument = instrument
                    }
                }
            }
            .response("Discard", appearance: .destructive, role: .none) {
                appState.modifiedInstrument = nil
                switch databaseState.exportDoneAction {
                case .closeWindow:
                    /// Fall back to the default guitar
                    appState.settings.app.instrument = Instrument[.guitar]
                    updateDatabase()
                    window.close()
                case .switchInstrument:
                    updateDatabase()
                case .doNothing:
                    break
                }
            }
            .response(appState.modifiedInstrument?.fileURL == nil ? "Export" : "Save", appearance: .suggested, role: .default) {
                if appState.modifiedInstrument?.fileURL == nil  {
                    /// Export the database
                    databaseState.exportDatabase.signal()
                } else {
                    saveDatabase()
                }
            }
            /// Import database dialog
            .fileImporter(
                open: databaseState.importDatabase,
                extensions: ["json"]
            ) { fileURL in
                appState.importDatabase(url: fileURL)
            }
    }

    func saveDatabase() {
        /// Make sure we use the correct instrument,
        /// when another is already selected the state is already changed.
        /// So, use the modified instrument.
        guard
            var instrument = appState.modifiedInstrument,
            let fileURL = instrument.fileURL,
            let index = appState.settings.app.customInstruments.firstIndex(where: { $0.fileURL == fileURL})
        else { return }

        do {
            let database = ChordsDatabase(
                instrument: appState.settings.core.instrument,
                definitions: appState.settings.core.chordDefinitions
            )
            let export  = try ChordUtils.exportToJSON(database: database)
            try export.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Update the list of custom instruments
            instrument.modified = false
            appState.settings.app.customInstruments[index] = instrument
            /// Clear the modified database
            appState.modifiedInstrument = nil
            switch databaseState.exportDoneAction {
            case .closeWindow:
                /// Select this instrument
                appState.settings.app.instrument = instrument
                updateDatabase()
                window.close()
            case .switchInstrument:
                /// Switch the instrument
                updateDatabase()
            case .doNothing:
                break
            }
        } catch {
            appState.scene.error = .fileNotSaved(error: error.localizedDescription)
        }
    }
}
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
    /// The dialogs for the *Content view*
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
            .fileExporter(
                open: databaseState.exportDatabase,
                initialName: "\(appState.settings.core.instrument.type.label)"
            ) { fileURL in
                if let export  = try? ChordUtils.exportToJSON(definitions: databaseState.allChords) {
                    try? export.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                    databaseState.databaseIsModified = false
                    switch databaseState.exportDoneAction {
                    case .closeWindow:
                        window.close()
                    default:
                        break
                    }
                }
            }
            /// The **Alert dialog** when a song is changed but not yet saved
            .alertDialog(
                visible: $databaseState.showChangedDatatabaseDialog,
                heading: "Export Changes?",
                id: "dirty-database-dialog",
                /// - Note: Use `extraChild` instead of `body` so I can use markup
                extraChild: {
                    let instrument = databaseState.allChords.first?.instrument.type ?? .guitar
                    VStack {
                        Text("The <b>\(instrument.description)</b> database is modified.")
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
                /// Revert the instrument
                appState.settings.core.instrument.type = databaseState.allChords.first?.instrument.type ?? .guitar

            }
            .response("Discard", appearance: .destructive, role: .none) {
                databaseState.databaseIsModified = false
                switch databaseState.exportDoneAction {
                case .closeWindow:
                    window.close()
                case .switchInstrument:
                    self.databaseState.allChords = getAllChordsForInstrument()
                    self.databaseState.filteredChords = getFilteredChords()
                    appState.editor.command = .updateSong
                }
            }
            .response("Export", appearance: .suggested, role: .default) {
                databaseState.exportDatabase.signal()
            }
    }
}
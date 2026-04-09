//
//  Views+Database+exportModifiedDialog.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Database {

    /// The dialog to export a modified database
    var exportModifiedDialog: AnyView {
        /// Attachment point
        Views.Empty()
            /// The **Alert dialog** when a database is changed but not yet saved
            .alertDialog(
                visible: $databaseState.showChangedDatatabaseDialog,
                heading: "\(appState.currentInstrument.fileURL == nil ? "Export" : "Save") Changes?",
                id: "dirty-database-dialog",
                /// - Note: Use `extraChild` instead of `body` so I can use markup
                extraChild: {
                    let instrument = appState.currentInstrument
                    VStack {
                        Text("The <b>\(instrument.kind.description), \(instrument.label)</b> database is modified.")
                            .useMarkup()
                            .style(.subtitle)
                            .padding(.bottom)
                        if instrument.fileURL == nil {
                            Text("You can not just save the database because it is <i>Build-in</i>\nIf you export it, it will be added as a custom instrument")
                            .wrap()
                            .useMarkup()
                            .caption()
                            .padding()
                        }
                        Text("Changes which are not saved will be permanently lost.")
                    }
                    /// - Note: Dirty trick to show all three buttons vertical
                    .frame(minWidth: 380)
                }                    // if appState.modifiedInstrument != nil {
                    //     appState.settings.app.instrumentID = appState.currentInstrument.id
                    // }
            )
            .response("Cancel", role: .close) {
                Idle {
                    /// Just go back to the previous selected instrument
                    databaseState.instrumentID = appState.settings.app.instrumentID
                }
            }
            .response("Discard", appearance: .destructive, role: .none) {
                appState.markCurrentInstrumentAsUnmodified()
                switch databaseState.saveDoneAction {
                case .closeWindow:
                    /// Fall back to the default guitar
                    appState.settings.app.instrumentID = Instrument[.guitar].id
                    appState.updateDatabase(main: false)
                    window.close()
                case .importDatabase:
                    /// Fall back to the default guitar in case the import failed or is canceled
                    appState.settings.app.instrumentID = Instrument[.guitar].id
                    updateDatabase()
                    databaseState.importDatabase.signal()
                case .switchInstrument, .useInstrument:
                    updateDatabase()
                case .newDatabase:
                    databaseState.showNewDatabaseDialog = true
                case .doNothing:
                    break
                }
            }
            .response(appState.currentInstrument.fileURL == nil ? "Export" : "Save", appearance: .suggested, role: .default) {
                if appState.currentInstrument.fileURL == nil  {
                    /// Export the database
                    databaseState.exportDatabase.signal()
                } else {
                    save(instrument: appState.currentInstrument)
                }
            }
    }
}
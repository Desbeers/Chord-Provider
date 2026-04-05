//
//  Views+Database+menu.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Database {
    // The menu `View
    var menu: AnyView {
        Menu(icon: .default(icon: .openMenu)) {
            MenuButton("New") {
                databaseState.newDatabase = true
                databaseState.showNewDatabaseDialog = true
            }
            MenuButton("Import") {
                if !appState.currentInstrument.modified {
                    databaseState.importDatabase.signal()
                } else {
                    databaseState.saveDoneAction = .importDatabase
                    databaseState.showChangedDatatabaseDialog = true
                }
            }
            MenuButton("Save") {
                databaseState.saveDoneAction = .useInstrument
                if appState.currentInstrument.fileURL == nil {
                    /// Export the database, it is build-in and cannot be saved directly
                    databaseState.exportDatabase.signal()
                } else {
                    save(instrument: appState.currentInstrument)
                }
            }
            MenuButton("Save As…") {
                databaseState.saveDoneAction = .useInstrument
                databaseState.exportDatabase.signal()
            }
        }
    }
}

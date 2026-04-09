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
    /// The menu `View`
    /// 
    /// I did not add `Save` here on purpose because I'm unable
    /// to disable the button when needed:
    /// - The database is *build-in* and can not be saved
    /// - The database is not modified
    var menu: AnyView {
        Menu(icon: .default(icon: .openMenu)) {
            MenuButton("New") {
                if !appState.currentInstrument.modified {
                    databaseState.newDatabase = true
                    databaseState.showNewDatabaseDialog = true
                } else {
                    databaseState.saveDoneAction = .newDatabase
                    databaseState.showChangedDatatabaseDialog = true
                }
            }
            MenuButton("Import") {
                if !appState.currentInstrument.modified {
                    databaseState.importDatabase.signal()
                } else {
                    databaseState.saveDoneAction = .importDatabase
                    databaseState.showChangedDatatabaseDialog = true
                }
            }
            MenuButton("Save As…") {
                databaseState.saveDoneAction = .useInstrument
                databaseState.exportDatabase.signal()
            }
        }
    }
}

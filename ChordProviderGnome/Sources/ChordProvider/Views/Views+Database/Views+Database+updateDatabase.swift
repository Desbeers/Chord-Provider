//
//  Views+Database+updateDatabase.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Database {

    /// Update the database after a new instrument selection
    func updateDatabase() {
        /// Bring the selected instrument to the App State
        appState.settings.app.instrumentID = databaseState.instrumentID
        /// Update the databse
        appState.updateDatabase(main: false)
        /// Filter the chords
        databaseState.getFilteredChords(allChords: appState.settings.core.chordDefinitions)
    }
}
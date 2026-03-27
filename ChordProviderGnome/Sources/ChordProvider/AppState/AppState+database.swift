//
//  AppState+database.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    ///  Import an instrument database
    /// - Parameter url: The URL of the database file
    mutating func importDatabase(url: URL) {
        do {
            let database = try ChordsDatabase(url: url)
            self.settings.app.instrument = database.instrument
            self.setDatabase(database)
            /// Add this database to the custom list
            self.settings.app.customInstruments.append(database.instrument)
        } catch {
            self.scene.error = ChordProviderError.databaseImportError(error: error.localizedDescription)
        }
    }

    ///  Update an instruent database
    /// - Parameter instrument: The ``Instrument`` to update
    mutating func updateDatabase(instrument: Instrument) {
        do {
            let database = try ChordsDatabase(instrument: instrument)
            self.setDatabase(database)
        } catch {
            self.scene.error = ChordProviderError.databaseImportError(error: error.localizedDescription)
            self.scene.showErrorDialog = true
        }
    }

    ///  Set the database information and update the song
    /// - Parameter database: The ``ChordsDatabase`` to set
    mutating private func setDatabase(_ database: ChordsDatabase) {
        self.settings.core.instrument = database.instrument
        self.settings.core.chordDefinitions = database.definitions
        self.editor.command = .updateSong
    }

    ///  Remove an instruent database
    /// - Parameter instrument: The ``Instrument`` to remove
    mutating func removeDatabase(instrument: Instrument) {
        if let index = self.settings.app.customInstruments
            .firstIndex(where: { $0.hashValue == instrument.hashValue}) {
            self.settings.app.customInstruments.remove(at: index)
        }
        if instrument == self.settings.app.instrument {
            /// The instrument was selected; reset to default
            self.settings.app.instrument = Instrument[.guitar]
            self.updateDatabase(instrument: Instrument[.guitar])
        }
    }
}

//
//  AppState+database.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Init the chords database when starting the application
    mutating func initDatabase() {
        /// Cleanup
        let allInstruments: [Instrument] = self.settings.app.instruments.compactMap { instrument in
            var copy = instrument
            copy.modified = false
            /// Ignore new instruments that where not saved last time
            return copy.id == "new" ? nil : copy
        }
        /// Make sure we always have the buildin instruments
        let result: Set<Instrument> = Set(Instrument.buildIn).union(allInstruments)

        self.settings.app.instruments = Array(result).sorted()

        self.updateDatabase(main: true)
    }

    /// Import an instrument database
    /// - Parameters:
    ///   - url: The file URL
    ///   - main: Bool if errors are for the main window
    mutating func importDatabase(url: URL, main: Bool) {
        do {
            let database = try ChordsDatabase(url: url)
            self.settings.app.instrumentID = database.instrument.id
            self.setDatabase(database)
            /// Add this database to the custom list
            if self.settings.app.instruments.first(where: { $0.fileURL == url }) == nil {
                self.settings.app.instruments.append(database.instrument)
                self.settings.app.instruments.sort()
            }
        } catch {
            self.scene.throwError(
                error: ChordProviderError.databaseImportError(error: error.localizedDescription),
                main: main
            )
        }
    }

    /// Update an instrument database
    /// - Parameter main: Bool if errors are for the main window
    mutating func updateDatabase(main: Bool) {
        do {
            let database = try ChordsDatabase(instrument: currentInstrument)
            self.setDatabase(database)
        } catch {
            self.scene.throwError(
                error: .databaseImportError(error: error.localizedDescription),
                main: main
            )
        }
    }

    ///  Set the database information and update the song
    /// - Parameter database: The ``ChordsDatabase`` to set
    mutating func setDatabase(_ database: ChordsDatabase) {
        self.settings.core.instrument = database.instrument
        self.settings.core.chordDefinitions = database.definitions.sorted()
        self.editor.command = .updateSong
    }

    /// Remove an instrument database
    /// - Parameters:
    ///   - instrument: The ``Instrument`` to update
    ///   - main: Bool if errors are for the main window
    mutating func removeDatabase(instrument: Instrument, main: Bool) {
        if instrument.id == self.settings.app.instrumentID {
            /// The instrument was selected; reset to default
            self.settings.app.instrumentID = Instrument[.guitar].id
            self.updateDatabase(main: main)
        }
        if let index = self.settings.app.instruments
            .firstIndex(where: { $0.id == instrument.id}) {
            self.settings.app.instruments.remove(at: index)
        }
    }

    var currentInstrument: Instrument {
        if let active = self.settings.app.instruments.first(where: { $0.id == self.settings.app.instrumentID }) {
            return active
        }
        /// Return default
        return Instrument[.guitar]
    }

    mutating func markCurrentInstrumentAsModified() {
        if let index = self.settings.app.instruments.firstIndex(where: { $0.id == self.settings.app.instrumentID }) {
            self.settings.app.instruments[index].modified = true
        }
    }

    mutating func markCurrentInstrumentUnmodified() {
        if let index = settings.app.instruments.firstIndex(where: { $0.id == settings.app.instrumentID }) {
            if settings.app.instruments[index].id == "new" {
                /// It is a new database, remove it from the list
                settings.app.instruments.remove(at: index)
            } else {
                /// Mark as unmodified
                settings.app.instruments[index].modified = false
            }
        }
    }
}

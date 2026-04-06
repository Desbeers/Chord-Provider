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
        let allInstruments: [Instrument] = settings.app.instruments.compactMap { instrument in
            var copy = instrument
            copy.modified = false
            /// Ignore new instruments that where not saved last time
            return copy.id == "new" ? nil : copy
        }
        /// Make sure we always have the buildin instruments
        let result: Set<Instrument> = Set(Instrument.buildIn).union(allInstruments)
        settings.app.instruments = Array(result).sorted()
        updateDatabase(main: true)
    }

    /// Import an instrument database
    /// - Parameters:
    ///   - url: The file URL
    ///   - main: Bool if errors are for the main window
    mutating func importDatabase(url: URL, main: Bool) {
        do {
            let database = try ChordsDatabase(url: url)
            settings.app.instrumentID = database.instrument.id
            setDatabase(database)
            /// Add this database to the custom list
            if settings.app.instruments.first(where: { $0.fileURL == url }) == nil {
                settings.app.instruments.append(database.instrument)
                settings.app.instruments.sort()
            }
        } catch {
            scene.throwError(
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
            setDatabase(database)
        } catch {
            scene.throwError(
                error: .databaseImportError(error: error.localizedDescription),
                main: main
            )
        }
    }

    ///  Set the database information and update the song
    /// - Parameter database: The ``ChordsDatabase`` to set
    mutating func setDatabase(_ database: ChordsDatabase) {
        editor.coreSettings.instrument = database.instrument
        editor.coreSettings.chordDefinitions = database.definitions.sorted()
        editor.command = .updateSong
    }

    /// Remove an instrument database
    /// - Parameters:
    ///   - instrument: The ``Instrument`` to update
    ///   - main: Bool if errors are for the main window
    mutating func removeDatabase(instrument: Instrument, main: Bool) {
        if instrument.id == settings.app.instrumentID {
            /// The instrument was selected; reset to default
            settings.app.instrumentID = Instrument[.guitar].id
            updateDatabase(main: main)
        }
        if let index = settings.app.instruments
            .firstIndex(where: { $0.id == instrument.id}) {
            settings.app.instruments.remove(at: index)
        }
    }

    /// Get the current instrument
    var currentInstrument: Instrument {
        if let active = settings.app.instruments.first(where: { $0.id == settings.app.instrumentID }) {
            return active
        }
        /// Return default
        return Instrument[.guitar]
    }

    /// Mark the current instrument as modified
    mutating func markCurrentInstrumentAsModified() {
        if let index = settings.app.instruments.firstIndex(where: { $0.id == settings.app.instrumentID }) {
            settings.app.instruments[index].modified = true
        }
    }

    /// Mark the current instrument as unmodified
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

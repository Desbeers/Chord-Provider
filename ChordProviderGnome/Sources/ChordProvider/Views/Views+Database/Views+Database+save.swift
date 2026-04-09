//
//  Views+Database+save.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Database {

    /// Save the database
    /// 
    /// Make sure we use the correct instrument,
    /// when another is already selected the state is already changed.
    /// So, use the modified instrument when not nil.
    /// 
    /// - Parameter instrument: The instrument to use
    func save(instrument: Instrument) {
        guard
            let fileURL = instrument.fileURL
        else {
            /// This should not happen
            appState.scene.throwError(
                error: .fileNotSaved(error: "No URL given"),
                main: false
            )
            return
        }
        do {
            /// Make an editable copy
            var instrument = instrument
            instrument.modified = false
            instrument.fileURL = fileURL
            let database = ChordsDatabase(
                instrument: instrument,
                definitions: appState.editor.coreSettings.chordDefinitions
            )
            let export  = try database.exportToJSON()
            try export.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Update the list of custom instruments
            if let index = appState.settings.app.instruments.firstIndex(where: { $0.id == "new"}) {
                /// Delete a new instrument; it is saved now
                appState.settings.app.instruments.remove(at: index)
            }
            if let index = appState.settings.app.instruments.firstIndex(where: { $0.fileURL == fileURL}) {
                /// Update the instruments list
                appState.settings.app.instruments[index] = instrument
            } else {
                /// Add it to the instruments list
                appState.settings.app.instruments.append(instrument)
                appState.settings.app.instruments.sort()
            }
            switch databaseState.saveDoneAction {
            case .closeWindow:
                /// Select this instrument and close
                databaseState.instrumentID = instrument.id
                updateDatabase()
                window.close()
            case .useInstrument:
                /// Use this instrument
                databaseState.instrumentID = instrument.id
                updateDatabase()
            case .switchInstrument:
                /// Switch the instrument to the current selection
                updateDatabase()
            case .importDatabase:
                /// Import a database
                databaseState.importDatabase.signal()
            case .newDatabase:
                databaseState.showNewDatabaseDialog = true
            case .doNothing:
                break
            }
        } catch {
            appState.scene.throwError(
                error: .fileNotSaved(error: error.localizedDescription),
                main: false
            )
        }
    }
}
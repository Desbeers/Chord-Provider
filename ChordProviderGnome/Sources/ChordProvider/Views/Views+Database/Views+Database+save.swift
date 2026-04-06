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
            let database = ChordsDatabase(
                instrument: instrument,
                definitions: appState.editor.coreSettings.chordDefinitions
            )
            let export  = try database.exportToJSON()
            try export.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            //Idle {
                /// Update the list of custom instruments
                if let index = appState.settings.app.instruments.firstIndex(where: { $0.fileURL == nil}) {
                    /// Delete the new instrument; it is saved now
                    appState.settings.app.instruments.remove(at: index)
                }
                if let index = appState.settings.app.instruments.firstIndex(where: { $0.fileURL == fileURL}) {
                    appState.settings.app.instruments[index] = instrument
                } else {
                    appState.settings.app.instruments.append(instrument)
                }
                switch databaseState.saveDoneAction {
                case .closeWindow:
                    /// Select this instrument
                    //appState.importDatabase(url: fileURL, main: false)
                    appState.settings.app.instrumentID = instrument.id
                    updateDatabase()
                    window.close()
                case .useInstrument:
                    /// Select this instrument
                    //appState.settings.app.instrument = instrument
                    //updateDatabase()
                    appState.importDatabase(url: fileURL, main: false)
                case .switchInstrument:
                    /// Switch the instrument
                    updateDatabase()
                case .importDatabase:
                    databaseState.importDatabase.signal()
                case .doNothing:
                    break
                }
            //}
        } catch {
            appState.scene.throwError(
                error: .fileNotSaved(error: error.localizedDescription),
                main: false
            )
        }
    }
}
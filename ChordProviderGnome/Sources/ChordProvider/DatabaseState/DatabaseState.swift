//
//  DatabaseState.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

/// The state of **Chord Provider** chord database
struct DatabaseState: Codable {
    /// The selected chord
    var chord: Chord.Root = .c
    /// The current instrument ID
    /// - Note: This is for internal use to keep track of modified instruments
    var instrumentID: String = Instrument[.guitar].id
    /// The filtered chords
    var filteredChords: [ChordDefinition] = []
    /// The optional search string
    var search: String = ""
    /// The current selected definition
    var definition: ChordDefinition?
    /// Bool to show the definition dialog
    var showDefinitionDialog: Bool = false
    /// Bool to show the new database dialog
    var showNewDatabaseDialog: Bool = false
    /// Bool if the chord database is new
    var newDatabase: Bool = false
    /// Bool if the chord definition is new
    var newChord: Bool = false
    /// Bool to show a dialog when the window is closed or the instrument has changed and the database is altered
    var showChangedDatatabaseDialog: Bool = false
    /// Bool to show a confirmation dialog to delete a chord
    var showDeleteChordDialog: Bool = false
    /// The action after saving an ``Instrument``
    var saveDoneAction: SaveDoneAction = .closeWindow
    /// Bool if the sidebar is visible
    var sidebarVisible = true

    // MARK: Signals

    /// A signal to export the database
    var exportDatabase = Signal()
    /// A signal to import a chords database
    var importDatabase = Signal()
}

extension DatabaseState {
    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        case sidebarVisible
    }
}

extension DatabaseState {

    /// Get all filtered chords
    /// - Returns: The filtered chords
    mutating func getFilteredChords(allChords: [ChordDefinition]) {
        /// Clear optional selected definition
        definition = nil
        var result = [ChordDefinition]()
        if search.isEmpty {
            result = allChords
                .filter { $0.root == chord }
        } else {
            result = allChords
                .filter { $0.name.starts(with: search) }
        }
        filteredChords = result
    }
}
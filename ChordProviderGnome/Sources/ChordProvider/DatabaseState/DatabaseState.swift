//
//  DatabaseState.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import SourceView
import Adwaita
import CAdw

/// The state of **Chord Provider** chord database
struct DatabaseState {
    /// The selected chord
    var chord: Chord.Root = .c
    /// All the chords for an intrument
    var allChords: [ChordDefinition] = []
    /// The filtered chords
    var filteredChords: [ChordDefinition] = []
    /// The optional search string
    var search: String = ""
    /// The current selected definition
    var definition: ChordDefinition?
    /// Bool to show the edit dialog
    var showEditDefinitionDialog: Bool = false
    /// Bool if the chord definition is new
    var newChord: Bool = false
    /// Bool if the database is modified
    var databaseIsModified: Bool = false
    /// Bool to show a dialog when the window is closed or the instrument has changed and the database is altered
    var showChangedDatatabaseDialog: Bool = false
    /// The action after exporting the database
    var exportDoneAction: ExportDoneAction = .closeWindow  

    // MARK: Signals

    /// A signal to export the database
    var exportDatabase = Signal()
}

extension DatabaseState {
    
    /// The action for the changed database dialog
    enum ExportDoneAction {
        /// Close the window
        case closeWindow
        /// Switch instrument
        case switchInstrument
    }
}
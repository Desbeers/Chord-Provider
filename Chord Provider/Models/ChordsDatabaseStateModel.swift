//
//  ChordsDatabaseStateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The observable chords database state for **Chord Provider**
@Observable final class ChordsDatabaseStateModel {
    /// All the chords for the current instrument
    var allChords: [ChordDefinition] = []
    /// The filtered chords as shown in a grid
    var chords: [ChordDefinition] = []
    /// The optional search string
    var search: String = ""
    /// Bool to show the file exporter dialog
    var showExportSheet: Bool = false
    /// The JSON data of the chord definitions
    var exportData: String = ""
    /// Bool if the chords should be editable
    var editChords: Bool = false
    /// The Navigation stack path
    var navigationStack: [ChordDefinition] = []
}

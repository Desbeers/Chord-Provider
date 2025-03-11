//
//  ChordsDatabaseStateModel.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
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
    /// The Navigation stack path
    var navigationStack: [ChordDefinition] = []
    /// Root selection
    var gridRoot: Chord.Root = .c
    /// Quality selection
    var gridQuality: Chord.Quality = .major
}

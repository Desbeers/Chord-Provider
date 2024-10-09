//
//  ChordDatabaseStateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

@Observable final class ChordDatabaseStateModel {
    var selectedTab: Instrument = .guitar

    var allChords: [ChordDefinition] = []

    var chords: [ChordDefinition] = []

    var search: String = ""

    /// Bool to show the file exporter dialog
    var showExportSheet: Bool = false

    var exportData: String = ""

    var editChords: Bool = false

    /// The Navigation stack path
    var navigationStack: [ChordDefinition] = []
}

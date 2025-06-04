//
//  AppSettings+Display.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Settings for displaying a song; unique for each scene
    struct Display: Equatable, Codable, Sendable {
        /// The paging of the song
        var paging: Paging = .asList
        /// The label style of the song
        var labelStyle: LabelStyle = .grid
        /// The instrument for the song
        var instrument: Chord.Instrument = .guitar
        /// Show the chord diagrams
        var showChords: Bool = true
        /// Show the chord diagrams inline with the song text
        var showInlineDiagrams: Bool = false
        /// The position for the chord diagrams
        var chordsPosition: ChordsPosition = .right
    }
}

extension AppSettings.Display {

    /// The label style of the song view
    enum LabelStyle: String, Equatable, Codable, Sendable {
        /// View the labels inline
        case inline
        /// View the labels in a grid
        case grid
    }

    /// The paging of the song view
    enum Paging: String, CaseIterable, Equatable, Codable, Sendable {
        /// View the song as a list
        case asList
        /// View the song in columns
        case asColumns
        /// The label for the paging
        var label: (text: String, sfSymbol: String, help: String) {
            switch self {
            case .asList:
                ("List", "list.bullet", "Show the song in a list")
            case .asColumns:
                ("Columns", "square.grid.2x2", "Show the song in columns")
            }
        }
    }

    /// Possible positions for the chord diagrams
    enum ChordsPosition: String, CaseIterable, Equatable, Codable, Sendable {
        /// Show diagrams on the right of the `View`
        case right = "Right"
        /// Show diagrams as the bottom of the `View`
        case bottom = "Bottom"
    }
}

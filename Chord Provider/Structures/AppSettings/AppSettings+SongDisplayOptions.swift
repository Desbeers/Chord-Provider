//
//  AppSettings+SongDisplayOptions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Options for displaying a song; unique for each scene
    struct SongDisplayOptions: Equatable, Codable, Sendable {
        /// Repeat the whole last chorus when using a *{chorus}* directive
        var repeatWholeChorus: Bool = false
        /// Show only lyrics
        var lyricsOnly: Bool = false
        /// The paging of the song
        var paging: Paging = .asList
        /// The label style of the song
        var labelStyle: LabelStyle = .grid
        /// The scale factor of the song
        var scale: Double = 1
        /// The style of the chords display
        var chords: Chord = .asName
        /// The instrument for the song
        var instrument: Instrument = .guitar
        /// Show the chord diagrams
        var showChords: Bool = true
        /// Show the chord diagrams inline with the song text
        var showInlineDiagrams: Bool = false
        /// The position for the chord diagrams
        var chordsPosition: ChordsPosition = .right
    }
}

extension AppSettings.SongDisplayOptions {

    /// The enum for a `Chord` display option
    enum Chord: String, Equatable, Codable, Sendable {
        /// Show the chord with its name
        case asName
        /// Show a chord with its diagram
        case asDiagram
    }

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

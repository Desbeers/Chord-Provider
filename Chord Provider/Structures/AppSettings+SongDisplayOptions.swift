//
//  AppSettings+SongDisplayOptions.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 28/09/2024.
//

import SwiftUI

extension AppSettings {

    /// Options for displaying a song; uniqur for each scene
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
        var instrument: Instrument = .guitarStandardETuning
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
    enum Chord: Equatable, Codable, Sendable {
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
        var label: some View {
            switch self {
            case .asList:
                Label("Single page", systemImage: "list.bullet")
            case .asColumns:
                Label("Columns", systemImage: "square.grid.2x2")
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

//
//  Song+DisplayOptions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension Song {

    // MARK: The structure for `Song` display options

    /// The structure for ``Song`` display options
    struct DisplayOptions: Codable, Equatable {
        /// The paging of the song
        var paging: Paging = .asList
        /// The label style of the song
        var label: LabelStyle = .grid
        /// Repeat the whole last chorus when using a *{chorus}* directive
        var repeatWholeChorus: Bool = false
        /// The scale factor of the song
        var scale: Double = 1
        /// The style of the chords display
        var chords: Chord = .asName
        /// The instrument for MIDI
        var midiInstrument: Midi.Instrument = .acousticSteelGuitar
        /// Show the chord diagrams
        var showChords: Bool = true
        /// Show the chord diagrams inline with the song text
        var showInlineDiagrams: Bool = false
        /// The position for the chord diagrams
        var chordsPosition: ChordsPosition = .right
    }
}

extension Song.DisplayOptions {

    /// The enum for a `Chord` display option
    enum Chord: Codable {
        /// Show the chord with its name
        case asName
        /// Show a chord with its diagram
        case asDiagram
    }
}

extension Song.DisplayOptions {

    /// The label style of the song view
    enum LabelStyle: String, Codable {
        /// View the labels inline
        case inline
        /// View the labels in a grid
        case grid
    }
}

extension Song.DisplayOptions {

    /// The paging of the song view
    enum Paging: String, CaseIterable, Codable {
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
}

extension Song.DisplayOptions {

    /// Possible positions for the chord diagrams
    enum ChordsPosition: String, CaseIterable, Codable {
        /// Show diagrams on the right of the `View`
        case right = "Right"
        /// Show diagrams as the bottom of the `View`
        case bottom = "Bottom"
    }
}

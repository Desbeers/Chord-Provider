//
//  Song+DisplayOptions.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension Song {

    /// The structure for ``Song`` display options
    struct DisplayOptions {
        /// The paging of the song
        var paging: Paging = .asList
        /// The label style of the song
        var label: LabelStyle = .grid
        /// The scale factor of the song
        var scale: Double = 1
        /// The style of the chords display
        var chords: Chord = .asName
        /// The instrument for MIDI
        var midiInstrument: Midi.Instrument = .acousticSteelGuitar
    }
}

extension Song.DisplayOptions {

    /// The enum for a `Chord` display option
    enum Chord {
        /// Show the chord with its name
        case asName
        /// Show a chord with its diagram
        case asDiagram
    }
}

extension Song.DisplayOptions {

    /// The label style of the song view
    enum LabelStyle {
        /// View the labels inline
        case inline
        /// View the labels in a grid
        case grid
    }
}

extension Song.DisplayOptions {

    /// The paging of the song view
    enum Paging: String, CaseIterable {
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

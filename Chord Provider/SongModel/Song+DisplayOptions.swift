//
//  Song+DisplayOptions.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities

extension Song {

    /// The structure for ``Song`` display options
    struct DisplayOptions {
        /// The style of the song
        var style: Style = .asGrid
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

    /// The style of the song view
    enum Style {
        /// View the song as a list
        case asList
        /// View the song as a grid
        case asGrid
    }
}

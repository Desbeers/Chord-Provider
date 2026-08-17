//
//  Utils+Samples.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Utils {

    enum Samples: String, Identifiable {

        /// Help
        case help = "Help"
        /// New song
        case newSong = "New Song"
        /// Sample song
        case swingLowSweetChariot = "Swing Low Sweet Chariot"

        // MARK: Debug Songs

        /// Pango
        case pangoMarkup = "Pango Markup"
        /// Debugging
        case debugWarnings = "Debug Warnings"
        /// Transposing
        case transpose = "Transpose"
        /// Chord definitions
        case chordDefinitions = "Chord Definitions"
        /// Brackets
        case brackets = "Brackets"
        /// Source Comments
        case sourceComments = "Source Comments"
        /// Long Stuff
        case longStuff = "Long Stuff"
        /// Grid
        case grid = "Grid"
        /// Tab
        case tab = "Tab"
        /// Difficult grid
        case difficultGrid = "Difficult Grid"
        /// Inline Chords
        case inlineChords = "Inline Chords"
        /// Complicated sample
        case mollyMalone = "Molly Malone"

        /// Identifiable protocol
        var id: Self { self }

        /// Debug samples
        static let debugSamples: [Samples] = [
            .pangoMarkup,
            .debugWarnings,
            .transpose,
            .chordDefinitions,
            .brackets,
            .sourceComments,
            .longStuff,
            .grid,
            .tab,
            .difficultGrid,
            .inlineChords,
            .mollyMalone
        ]
    }
}

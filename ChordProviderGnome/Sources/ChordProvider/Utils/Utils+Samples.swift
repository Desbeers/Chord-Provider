//
//  Utils+Samples.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
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
            .mollyMalone
        ]
    }
}

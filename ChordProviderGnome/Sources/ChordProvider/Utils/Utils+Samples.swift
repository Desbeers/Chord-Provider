//
//  Utils+Samples.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Utils {

    enum Samples: String, Identifiable {
        var id: Self { self }
        case help = "Help"
        case newSong = "New Song"
        case swingLowSweetChariot = "Swing Low Sweet Chariot"

        // MARK: Debug Songs

        case pangoMarkup = "Pango Markup"
        case debugWarnings = "Debug Warnings"
        case transpose = "Transpose"
        case chordDefinitions = "Chord Definitions"
        case mollyMalone = "Molly Malone"
    }
}

//
//  ChordProConfig.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of an official ChordPro config
struct ChordProConfig: Codable {
    /// PDF settings
    var pdf = PDF()
    /// Chord definitions
    var chords: [ChordPro.Instrument.Chord] = []
}

extension ChordProConfig {
    /// The structure of PDF settings
    struct PDF: Codable {
        /// The color theme
        var theme = AppSettings.Style.Theme()
        /// Fonts
        var fonts: [String: FontOptions] = [:]
        /// Font config
        var fontconfig: [String: String] = [:]
    }
    /// The structure of font options
    struct FontOptions: Codable {
        /// The file as path
        var file: String
        /// The color
        var color: String = "#000000"
        /// The optional background color
        var background: String?
        /// The size of the font
        var size: Int = 10
    }
}

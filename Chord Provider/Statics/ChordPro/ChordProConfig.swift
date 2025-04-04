//
//  ChordProConfig.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

struct ChordProConfig: Codable {
    var pdf = PDF()
    var chords: [ChordPro.Instrument.Chord] = []
}

extension ChordProConfig {

    struct PDF: Codable {
        var theme = AppSettings.Style.Theme()
        var fonts: [String: FontOptions] = [:]
        var fontdir = ["/Library/Fonts", "/System/Library/Fonts", "~/Fonts"]
        var fontconfig: [String: String] = [:]
    }

    struct FontOptions: Codable {
        var color: String = "#000000"
        var background: String?
        var size: Int = 10
    }
}

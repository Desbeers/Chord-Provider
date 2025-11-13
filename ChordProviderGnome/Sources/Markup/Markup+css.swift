//
//  Markup+css.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CChordProvider

extension Markup {
    
    enum Class: String, CustomStringConvertible {
        var description: String {
            self.rawValue
        }
        case theme = "theme"
        case standard
        case title = "song-title"
        case subtitle = "song-subtitle"
        case sectionHeader = "section-header"
        case sectionChorus = "section-chorus"
        case tagLabel = "tag-label"
        case commentLabel = "comment-label"
        case repeatChorus = "repeat-chorus"
        case chord
        case textblock
        case grid
        case tab
        case strum
        case plainButton = "plain-button"
        case metadata
    }

    static let baseFontSize: Double = 12.5

    static func css(zoom: Double, dark: Bool) -> String {
"""
.background {
    font-family: "Adwaita Sans";
    font-size: 11pt;
}
.standard, .strum {
    font-size: \(baseFontSize * zoom)px;
}
.song-title {
    font-size: \(1.4 * baseFontSize)px;
    font-weight: bold;
}
.song-subtitle {
    font-size: \(1.2 * baseFontSize)px;
}
.section-header {
    font-size: \(1.2 * baseFontSize * zoom)px;
    font-weight: bold;
}
.tag-label {
    font-size: \(0.8 * baseFontSize * zoom)px;
    color: #000;
    background-color: #ffc7c2;
    padding: 0.5em;
    border-radius: 0.5em;
}
.comment-label {
    font-size: \(0.8 * baseFontSize * zoom)px;
    color: #000;
    background-color: #f1e8c9;
    padding: 0.5em;
    border-radius: 0.5em;
}
.section-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    font-weight: bold;
    color: #000;
    background-color: \(dark ? "#98989d" : "#c8d3ca");
    padding: 0.5em;
    border-radius: 0.5em;
}
.repeat-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    color: #000;
    background-color: \(dark ? "#98989d" : "#c8d3ca");
    padding: 0.5em;
    border-radius: 0.5em;
}
.chord, .grid {
    font-size: \(1.1 * baseFontSize * zoom)px;
    color: \(dark ? "#cee3da" : "#78847f");
}
.textblock {
    font-size: \(baseFontSize * zoom)px;
}
.tab {
    font-size: \(baseFontSize * zoom)px;
    font-family: monospace;
}
.plain-button {
    color: \(dark ? "#cee3da" : "#78847f");
    font-size: 1.1em;
}
.metadata {
        font-size: 12px;
}
"""
    }
}

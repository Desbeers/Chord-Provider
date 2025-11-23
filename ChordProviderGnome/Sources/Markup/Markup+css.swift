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
        case none
        case theme = "theme"
        case standard
        case bold
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
        case gridChord = "grid-chord"
        case tab
        case strum
        case plainButton = "plain-button"
        case metadata
        case chordButton = "chord-button"

        case selectedChord = "selected-chord"

        case svgIcon = "svg-icon"

        case logWarning = "log-warning"
        case logError = "log-error"
        case logDebug = "log-debug"
        case logInfo = "log-info"
        case logNotice = "log-notice"
        case logFault = "log-fault"
    }

    static let baseFontSize: Double = 12.5

    static func css(zoom: Double, dark: Bool) -> String {
"""
:root {
    --chordprovider-accent-bg-color: \(dark ? "#57575a" : "#c8d3ca");
    --chordprovider-accent-color: \(dark ? "#cee3da" : "#78847f");
}
.background {
    font-family: "Adwaita Sans";
    font-size: 11pt;
}
.standard, .strum {
    font-size: \(baseFontSize * zoom)px;
}
.bold {
    font-weight: bold;
}
.song-title {
    font-size: \(1.4 * baseFontSize)px;
    font-weight: bold;
}
.song-subtitle {
    font-size: \(1.2 * baseFontSize)px;
    font-weight: normal;
}
.section-header {
    font-size: \(1.2 * baseFontSize * zoom)px;
    font-weight: bold;
}
.tag-label {
    font-size: \(0.8 * baseFontSize * zoom)px;
    font-weight: normal;
    color: \(dark ? "#eee" : "#000");
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.comment-label {
    font-size: \(0.8 * baseFontSize * zoom)px;
    color: \(dark ? "#eee" : "#000");
    background-color: \(dark ? "#5b574c" : "#f1e8c9");
    padding: 0.5em;
    border-radius: 0.5em;
}
.section-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    font-weight: bold;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.repeat-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.grid {
    font-size: \(1.1 * baseFontSize * zoom)px;
}
.chord, .grid-chord {
    font-size: \(1.1 * baseFontSize * zoom)px;
    color: var( --chordprovider-accent-color);
}
.textblock {
    font-size: \(baseFontSize * zoom)px;
}
.tab {
    font-size: \(baseFontSize * zoom)px;
    font-family: monospace;
}
.plain-button {
    color: var( --chordprovider-accent-color);
    font-size: \(baseFontSize)px;
    font-weight: normal;
}
.metadata {
    font-size: 12px;
}
.chord-button {
    padding: 5px 0 0 0;
}
.chord-button .chord {
    font-size: \(baseFontSize)px;
    font-weight: normal;
}
.selected-chord {
    background: var(--card-bg-color);
    border-radius: 0.6em;
}
.log {
    padding: 4px;
    border-radius: 4px;
    margin: 4px;
    color: var(--dark-5);
}
.log-info {
    background-color: var(--green-1);
}
.log-notice {
    background-color: var(--blue-1);
}
.log-warning {
    background-color: var(--orange-1);
}
.log-error {
    background-color: var(--red-1);
}
.caption {
    font-size: 10px;
}
.svg-icon {
    filter: invert(\(dark ? 90 : 40)%);
}
"""
    }
}

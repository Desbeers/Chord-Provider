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
        case tab
        case strum
        case plainButton = "plain-button"
        case metadata
        case chordButton = "chord-button"

        case selectedChord = "selected-chord"

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
    --chordprovider-accent-bg-color: \(dark ? "#98989d" : "#c8d3ca");
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
    color: #000;
    background-color: var(--chordprovider-accent-bg-color);
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
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.repeat-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    color: #000;
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.chord, .grid {
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
.log-warning {
    color: var(--warning-color);
}
.log-error {
    color: var(--error-color);
}
"""
    }
}

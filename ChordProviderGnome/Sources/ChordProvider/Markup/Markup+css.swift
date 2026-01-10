//
//  Markup+css.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import CChordProvider

extension Markup {

    /// Defines CSS class names used for styling UI elements
    enum Class: String, CustomStringConvertible {

        /// The raw CSS class name
        var description: String { self.rawValue }

        /// Don't style; there is no CSS declaration for this
        case none

        // MARK: Text Styles

        /// Standard text or default-styled element
        case standard
        /// Bold text styling
        case bold
        /// Caption text, typically smaller or secondary
        case caption
        /// Primary song title
        case title = "song-title"
        /// Secondary title, such as a subtitle or artist
        case subtitle = "song-subtitle"
        /// Metadata display, such as author, tempo, or key
        case metadata
        /// Represents an intentionally empty line
        case emptyLine = "empty-line"
        /// An error
        case error

        // MARK: Sections

        /// Header for a section
        case sectionHeader = "section-header"
        /// Section representing a chorus
        case sectionChorus = "section-chorus"
        /// Section representing a grid
        case sectionGrid = "section-grid"
        /// Section representing a textblock
        case sectionTextblock = "section-textblock"
        /// Section representing a tab
        case sectionTab = "section-tab"
        /// Section representing a strum
        case sectionStrum = "section-strum"
        /// Section representing a repeated chorus
        case sectionRepeatChorus = "section-repeat-chorus"

        // MARK: Buttons

        /// Button used for tag selection or display
        case tagButton = "tag-button"
        /// Button used in editor-related controls
        case editorButton = "editor-button"
        /// Button with minimal or no styling
        case plainButton = "plain-button"
        /// Button associated with a chord action or selection
        case chordButton = "chord-button"
        /// Button used to display or open a chord diagram
        case chordDiagramButton = "chord-diagram-button"

        // MARK: Labels

        /// Label displaying a tag
        case tagLabel = "tag-label"
        /// Label displaying a comment
        case commentLabel = "comment-label"

        // MARK: Chords

        /// Inline chord text
        case chord
        /// Highlighted or currently selected chord
        case selectedChord = "selected-chord"
        /// Chord text indicating an error or invalid chord
        case chordError = "chord-error"

        // MARK: Icons

        /// SVG icon element
        case svgIcon = "svg-icon"

        // MARK: Logging

        /// Base class for log entries
        case log
        /// Log entry used for debug output
        case logDebug = "log-debug"
        /// Log entry containing informational output
        case logInfo = "log-info"
        /// Log entry for notable but non-error conditions
        case logNotice = "log-notice"
        /// Log entry indicating a warning
        case logWarning = "log-warning"
        /// Log entry indicating an error
        case logError = "log-error"
        /// Log entry indicating a critical fault
        case logFault = "log-fault"
    }

    /// The base font size
    static let baseFontSize: Double = 12.5

    /// The CSS declarations
    static func css(zoom: Double, dark: Bool, editorFontSize: Int) -> String {
"""
:root {
    --chordprovider-accent-bg-color: \(dark ? "#57575a" : "#c8d3ca");
    --chordprovider-accent-color: \(dark ? "#cee3da" : "#78847f");
}

/* Text Styles */

.standard, .section-strum {
    font-size: \(baseFontSize * zoom)px;
}
.empty-line {
    font-size: \(baseFontSize * zoom * 0.25)px;
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
.caption {
    font-size: 10px;
}
.metadata {
    font-size: \(baseFontSize)px;
}

/* Sections */

.section-header {
    font-size: \(1.2 * baseFontSize * zoom)px;
    font-weight: bold;
}
.section-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    font-weight: bold;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.section-grid {
    font-size: \(1.1 * baseFontSize * zoom)px;
}
.section-textblock {
    font-size: \(baseFontSize * zoom)px;
}
.section-tab {
    font-size: \(baseFontSize * zoom)px;
    font-family: monospace;
}
.section-repeat-chorus {
    font-size: \(1 * baseFontSize * zoom)px;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-accent-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}

/* Buttons */

.tag-label, .tag-button {
    font-size: \(0.8 * baseFontSize)px;
    font-weight: normal;
    color: \(dark ? "#eee" : "#000");
    background-color: var(--headerbar-shade-color);
    padding: 0.5em;
    border-radius: 0.5em;
    transition: 0.15s;
}
.editor-button {
    font-size: \(0.9 * baseFontSize)px;
    font-weight: normal;
    padding: 0.5em;
    border-radius: 0.5em;
    transition: 0.15s;
}
.tag-button:hover, .editor-button:hover {
    background-color: var(--shade-color);
}
.plain-button {
    color: var(--chordprovider-accent-color);
    font-size: \(baseFontSize)px;
    font-weight: normal;
}
.chord-button {
    padding: 5px 0 0 0;
}
.chord-button .chord, .chord-diagram-button {
    font-size: \(baseFontSize)px;
    font-weight: bold;
}
.chord-diagram-button {
    margin: 0;
    padding: 0 2px;
}

/* Labels */

.comment-label {
    font-size: \(0.8 * baseFontSize * zoom)px;
    color: \(dark ? "#eee" : "#000");
    background-color: \(dark ? "#5b574c" : "#f1e8c9");
    padding: 0.5em;
    border-radius: 0.5em;
}

/* Chords */

.chord {
    font-size: \(1.1 * baseFontSize * zoom)px;
    color: var(--chordprovider-accent-color);
}
.chord-error {
    font-size: \(1.1 * baseFontSize * zoom)px;
    color: var(--destructive-color);
}
.selected-chord {
    background: var(--card-bg-color);
    border-radius: 0.6em;
}

/* Icons */

.svg-icon {
    filter: invert(\(dark ? 90 : 40)%);
}

/* Logging */

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
.log-debug {
    background-color: var(--yellow-1);
}
.log-fault {
    background-color: var(--red-5);
}

/* Editor */

textview { 
    font-family: Monospace; font-size: \(editorFontSize)pt;
}

gutter {
    background-color: var(--headerbar-backdrop-color);
}
gutterrenderer {
    padding-right: 4px;
}

popover button {
    font-size: 10px;
    padding: 2px 8px;
    font-weight: normal;
}

/* Define Chord */

toggle-group .toggle {
    padding: 0;
}
"""
    }
}

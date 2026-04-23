//
//  Markup+css.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Markup {

    /// Defines CSS class names used for styling UI elements
    enum Class: String, CustomStringConvertible {

        /// The raw CSS class name
        var description: String { self.rawValue }

        /// Don't style; there is no CSS declaration for this
        case none

        /// The define dialog
        case define

        /// The welcome image
        case welcomeImage = "welcome-image"

        // MARK: Text Styles

        /// Standard text or default-styled element
        case standard
        /// Bold text styling
        case bold
        /// Underline text styling
        case underline
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
        /// Error
        case error
        // Accent
        case accent
        /// Dimmed
        case dimmed

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
        case chordDiagramButton = "chord-diagram-button"
        /// Button used to play a chord with MIDI
        case midiButton = "midi-button"

        // MARK: Toggles

        /// Toggle used to display or open a chord diagram
        case chordDiagramToggle = "chord-diagram-toggle"
        /// Toggle in the page header
        case pageHeaderToggle = "page-header-toggle"

        // MARK: Labels

        /// Label displaying a tag
        case tagLabel = "tag-label"
        /// Label displaying a comment
        case commentLabel = "comment-label"
        /// Label displaying a a addition to the editor
        case addToEditorLabel = "add-to-editor-label"

        // MARK: Chords

        /// Inline chord text
        case chord
        /// Highlighted or currently selected chord
        case selectedChord = "selected-chord"
        /// Chord text indicating an error or invalid chord
        case chordError = "chord-error"
        /// Chord-highlight
        /// - Note: For playing grids
        case chordHighlight = "chord-highlight"

        /// Accent stroke
        case strokeAccent = "stroke-accent"
        /// Arpeggio stroke
        case strokeArpeggio = "stroke-arpeggio"
        /// Arpeggio Accent stroke
        case strokeArpeggioAccent = "stroke-arpeggio-accent"
        /// Muted stroke
        case strokeMuted = "stroke-muted"
        /// Muted Accent stroke
        case strokeMutedAccent = "stroke-muted-accent"
        /// Staccato stroke
        case strokeStaccato = "stroke-staccato"
        /// Staccato Accent stroke
        case strokeStaccatoAccent = "stroke-staccato-accent"
        /// No stroke
        case strokeNone = "stroke-none"


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
    static let baseFontSize: Double = 1

    /// The CSS declarations
    static func css(theme: AppSettings.Theme, dark: Bool) -> String {

        let colors = theme.colorScheme.colors(dark: dark)

return """
:root {
    --chordprovider-window-start: \(colors.windowStart);
    --chordprovider-window-end: \(colors.windowEnd);

    --chordprovider-chord-color: \(colors.chordColor);

    --chordprovider-label-bg-color: \(colors.labelBackgroundColor);
}

\(theme.colorfullWindow ? """

/* Window Background */

window, dialog sheet {
    background-image: linear-gradient(135deg, var(--chordprovider-window-start), var(--chordprovider-window-end));
}

.sidebar-pane {
	background-color: var(--chordprovider-window-start);
}
""" : "")

\(theme.colorScheme != .accent ? """

/* Accent Color */

:root {
    --accent-bg-color: \(colors.accentBackgroundColor);
}
""" : "")

/* Links: make the always blue insead of accent color */

label.link {
    --accent-color: \(dark ? "#8ed5fe" : "#1974cf");
}
\(dark && theme.colorfullWindow ? """

/* Popovers */

popover contents, popover arrow {
    background: var(--chordprovider-window-end);
}

""" : "")

/* Welcome image */

.welcome-image {
    border-radius: 20px;
    /* filter: opacity(0.5) drop-shadow(0 0 0 var(--accent-color)); */
    /* filter: invert(\(dark ? 90 : 0)%); */
    background: var(--accent-bg-color);
}

/* Text Styles */

.standard, .section-strum {
    font-size: \(baseFontSize * theme.zoom)rem;
}
.empty-line {
    padding: 0.5rem;
}
.bold {
    font-weight: bold;
}
.underline{
    text-decoration: underline;
}
.song-title {
    font-size: \(1.4 * baseFontSize)rem;
    font-weight: bold;
}
.song-subtitle {
    font-size: \(1.2 * baseFontSize)rem;
    font-weight: normal;
}
.caption {
    font-size: \(0.8 * baseFontSize)rem;
}
.metadata {
    font-size: \(baseFontSize)rem;
}

.dimmed {
    opacity: 0.5;
}

/* Sections */

.section-header {
    font-size: \(1.2 * baseFontSize * theme.zoom)rem;
    font-weight: bold;
}
.section-chorus {
    font-size: \(1 * baseFontSize * theme.zoom)rem;
    font-weight: bold;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-label-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}
.section-grid {
    font-size: \(1.1 * baseFontSize * theme.zoom)rem;
}
.section-textblock {
    font-size: \(baseFontSize * theme.zoom)rem;
}
.section-tab {
    font-size: \(baseFontSize * theme.zoom)rem;
    font-family: monospace;
}
.section-repeat-chorus {
    font-size: \(1 * baseFontSize * theme.zoom)rem;
    color: \(dark ? "#fff" : "#000");
    background-color: var(--chordprovider-label-bg-color);
    padding: 0.5em;
    border-radius: 0.5em;
}

/* Buttons */

.tag-label, .tag-button {
    font-size: \(0.8 * baseFontSize)rem;
    font-weight: normal;
    color: \(dark ? "#eee" : "#000");
    background-color: var(--headerbar-shade-color);
    padding: 0.5em;
    border-radius: 0.5em;
    transition: 0.15s;
}

.editor-button {
    font-size: \(0.8 * baseFontSize)rem;
    font-weight: normal;
    background: none;
    transition: 0.15s;
    min-height: 12px;
}
.editor-button:checked {
    background: var(--shade-color);
}

.tag-button:hover, .editor-button:hover {
    background-color: var(--shade-color);
}
.plain-button {
    font-size: \(baseFontSize)rem;
    font-weight: normal;
}
.chord-diagram-button {
    padding: 0;
    font-size: \(baseFontSize)rem;
}

.midi-button {
    margin: 0;
    padding: 0 0.2rem;
    font-size: \(baseFontSize)rem;
    color: var(--chordprovider-chord-color);
}

.midi-button image {
    opacity: 0.4;
}

/* Toggles */

.chord-diagram-toggle {
    margin: 0;
    padding: 0;
    font-size: \(baseFontSize * theme.zoom)rem;
}

.page-header-toggle {
    margin: 4px;
    padding: 0 4px;
    font-weight: normal;
}

/* Labels */

.comment-label {
    font-size: \(0.8 * baseFontSize * theme.zoom)rem;
    color: \(dark ? "#eee" : "#000");
    background-color: \(dark ? "#606130" : "#f6f1df");
    padding: 0.5em;
    border-radius: 0.4em;
}

.add-to-editor-label {
    color: var(--accent-color);
    font-weight: bold;
}

/* Chords */

.chord {
    margin-top: \(3 * theme.zoom)px;
    margin-bottom: \(1 * theme.zoom)px;
    color: var(--chordprovider-chord-color);
}
.chord-error {
    color: var(--destructive-color);
}
.selected-chord {
    background: var(--card-bg-color);
    border-radius: 0.6em;
}
.chord-highlight {
    background-color: var(--chordprovider-label-bg-color);
    border-radius: 0.2em;
}

.stroke-accent {
    font-size: 1.2em;
}
.stroke-arpeggio {
    font-style: italic;
}
.stroke-arpeggio-accent {
    font-size: 1.2em;
    font-style: italic;
}
.stroke-muted {
    opacity: 0.6;
}
.stroke-muted-accent {
    font-size: 1.2em;
    opacity: 0.6;
}
.stroke-staccato {
    font-size: 0.8em;
}
.stroke-staccato-accent {
    font-size: 0.95em;
}
.stroke-none {
    opacity: 0;
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
    font-family: Monospace; font-size: \(theme.editorFontSize.rawValue)pt;
}

gutter {
    background-color: var(--headerbar-backdrop-color);
}
gutterrenderer {
    padding-right: 4px;
}

popover button {
    font-size: \(0.8 * baseFontSize)rem;
    padding: 2px 8px;
    font-weight: normal;
}

/* Define Chord */

.define toggle-group .toggle {
    padding: 0;
}
"""
    }
}

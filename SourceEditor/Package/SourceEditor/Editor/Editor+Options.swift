//
//  Editor+Options.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

extension Editor {

    /// Options for the source editor.
    public struct Options: Codable, Equatable {

        /// Bool if the editor is showing line numbers.
        public var showLineNumbers: Bool = true
        /// Bool if the editor should wrap lines.
        public var wrapLines: Bool = true
        /// Bool to highlight the current line.
        public var highlightCurrentLine: Bool = true
        /// The font size of the editor, as a percentage.
        public var fontSize: Int = 100
        /// Bool to use a monospace font
        public var monoSpaceFont: Bool = true
        /// Bool if spelling is enabled.
        public var spelling: Bool = false
        /// The scheme.
        public var scheme: String = "Adwaita"
        /// The mini map.
        public var showMiniMap: Bool = true
        /// Colorfull Window
        public var colorfullWindow: Bool = false

        /// Init the options.
        public init() {
            // Default values.
        }
    }
}

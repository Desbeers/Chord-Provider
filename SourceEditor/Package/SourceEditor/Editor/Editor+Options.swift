//
//  Editor+Options.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor {

    /// Options for the source editor.
    public struct Options: Codable, Equatable {

        /// The current language of the Source View.
        public var language: Editor.Language = .def
        /// Bool if the text is editable.
        public var editable: Bool = true
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
        public var scheme: Editor.Scheme = .init("Adwaita")
        /// The mini map.
        public var showMiniMap: Bool = true
        /// Colorfull Window
        public var colorfullWindow: Bool = false

        /// Init the options for the source editor.
        /// - Parameters:
        ///   - language: The current language of the Source View.
        ///   - editable: Bool if the text is editable.
        ///   - showLineNumbers: Bool if the editor is showing line numbers.
        ///   - wrapLines: Bool if the editor should wrap lines.
        ///   - highlightCurrentLine: Bool to highlight the current line.
        ///   - fontSize: The font size of the editor, as a percentage.
        ///   - monoSpaceFont: Bool to use a monospace font.
        ///   - spelling: Bool if spelling is enabled.
        ///   - scheme: The scheme.
        ///   - showMiniMap: Bool if the mini map is shown.
        ///   - colorfullWindow: Bool if the window is colorfull.
        public init(
            language: Editor.Language = .def,
            editable: Bool = true,
            showLineNumbers: Bool = true,
            wrapLines: Bool = true,
            highlightCurrentLine: Bool = true,
            fontSize: Int = 100,
            monoSpaceFont: Bool = true,
            spelling: Bool = false,
            scheme: Editor.Scheme = .init("Adwaita"),
            showMiniMap: Bool = true,
            colorfullWindow: Bool = false
        ) {
            self.language = language
            self.editable = editable
            self.showLineNumbers = showLineNumbers
            self.wrapLines = wrapLines
            self.highlightCurrentLine = highlightCurrentLine
            self.fontSize = fontSize
            self.monoSpaceFont = monoSpaceFont
            self.spelling = spelling
            self.scheme = scheme
            self.showMiniMap = showMiniMap
            self.colorfullWindow = colorfullWindow
        }
    }
}

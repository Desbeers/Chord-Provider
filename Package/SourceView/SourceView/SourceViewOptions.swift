//
//  SourceViewOptions.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation

    /// Settings for the source editor
    public struct SourceViewOptions: Codable, Equatable {

        /// Init the options
        public init() {
            // Default values
        }

        /// Bool if the editor is showing line numbers
        public var showLineNumbers: Bool = true
        /// Bool if the editor should wrap lines
        public var wrapLines: Bool = true
        /// Bool to highlight the current line
        public var highlightCurrentLine = true
        /// The font size of the editor
        public var fontSize: Int = 100
    }

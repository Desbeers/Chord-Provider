//
//  Editor+Bridge.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita

extension Editor {

    /// The bridge between `GtkSourceView` and `Swift`.
    public struct Bridge {

        /// The current line number of the cursor.
        public var currentLineNumber: Int = 0
        /// The total number of lines.
        public var lineCount: Int = 0
        /// Bool if the editor is at the start of a line.
        /// - Note: Used to check if 'insert' commands are available.
        public var isAtBeginningOfLine: Bool = false
        /// Bool if the editor has a selection.
        public var hasSelection: Bool = false
        /// A signal to focus search in the editor.
        public var focusSearch = Signal()
        /// A signal to focus replace in the editor.
        public var focusReplace = Signal()

        /// The state of the search for the bridge.
        var search = Search()
        /// Bool to show the search bar.
        public var showSearchBar: Bool = false

        /// The current language of the Source View.
        public var language: String?
        /// Information about the styles of the scheme.
        public var styleInfo: [Editor.StyleInfo] = []
        /// Bool if the content is modified
        public var modified: Bool = false
        /// The location of the current document, if it has one.
        public var fileURL: URL?
        /// Init the bridge.
        public init() {
            // Init with default values
        }
    }
}

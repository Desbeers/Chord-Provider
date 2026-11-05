//
//  SourceViewBridge.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CGtkSourceView

/// The bridge between `GtkSourceView` and `Swift`
public struct SourceViewBridge {

    /// The command for the editor
    public var command: SourceViewCommand?
    /// The current line number of the cursor
    public var currentLineNumber: Int = 0
    /// The total number of lines
    public var totalLineNumbers: Int = 0

    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false

    /// Bool if the editor has a selection
    public var hasSelection: Bool = false

    /// A signal to focus search in the editor
    public var focusSearch = Signal()
    /// A signal to focus replace in the editor
    public var focusReplace = Signal()

    /// The state of the search
    public var search = SearchState()
    /// Bool to show te search bar
    public var showSearchBar: Bool = false

    /// The current language of the Source View
    public var language: String?

    /// Init the bridge
    public init() {
        // Init with default values
    }
}

//
//  SourceViewCommand.swift
//  SourceView
//
//  © 2026 Nick Berendsen
//

import Foundation

/// Command to pass to the editor
///
/// Important:
///
/// Always set or edit content with a *command*,
/// or else the text will be ignored.
///
/// Never touch the buffer content directly!
public enum SourceViewCommand: Sendable {

    // MARK: Inserts

    /// Open new content.
    /// - Note: If an URL is given; the editor language will be set automaticly.
    case openNewContent(_: String, url: URL? = nil)
    /// Insert a `Marker` at the cursor position
    case insertMarker(start: String, end: String, block: Bool)
    /// Replace all text
    case replaceAllText(_: String)
    /// Append text to the end of the source
    case appendText(_: String)
    /// Replace all text on a specific line in the editor
    case replaceLineText(_: String)

    // MARK: Search commands

    /// Search
    case search(_: SourceViewBridge.SearchDirection)
    /// Replace match
    case replaceSearchMatch(with: String)
    /// Replace all matches
    case replaceAllSearchMatches(with: String)

    // MARK: Search options

    /// Use regular expressions
    case regularExpressions(_: Bool)
    /// Search must match whole words
    case matchWholeWordOnly(_: Bool)
    /// Search is case sensitive
    case caseSensitive(_: Bool)

    /// Auto language setting
    case setLanguage(_: URL)

    // MARK: Other

    /// Clear the current selection
    case clearSelection
    /// Schedule to update the content
    case updateContent
}

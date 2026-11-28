//
//  Editor+Command.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Editor {

    /// Command to pass to the editor.
    ///
    /// Important:
    ///
    /// Always set or edit content with a *command*,
    /// or else the text will be ignored.
    ///
    /// Never touch the buffer content directly!
    public enum Command {

        // MARK: File handlers

        /// Open new content.
        /// - Note: If a URL is given, the editor language will be set automatically.
        case new(_: String, url: URL? = nil)
        /// Open existing URL.
        case open(URL, completion: ((Result<Void, Error>) -> Void)? = nil)
        /// Save the editor content.
        case save(as: URL? = nil)
        /// Mark as unmodified.
        case markAsUnmodified

        // MARK: Inserts

        /// Insert a `Marker` at the cursor position.
        case insertMarker(start: String, end: String, block: Bool)
        /// Replace all text.
        case replaceAllText(_: String)
        /// Append text to the end of the source.
        case appendText(_: String)
        /// Replace the text from the cursor to the end of the line.
        case replaceLineText(_: String)

        // MARK: Search commands

        /// Search.
        case search(_: Editor.Bridge.SearchDirection)
        /// Replace match.
        case replaceSearchMatch(with: String)
        /// Replace all matches.
        case replaceAllSearchMatches(with: String)

        // MARK: Search options

        /// Use regular expressions.
        case regularExpressions(_: Bool)
        /// Search must match whole words.
        case matchWholeWordOnly(_: Bool)
        /// Search is case sensitive.
        case caseSensitive(_: Bool)

        // MARK: Other

        /// Clear the current selection.
        case clearSelection
        /// Schedule to update the content.
        case updateContent
    }
}

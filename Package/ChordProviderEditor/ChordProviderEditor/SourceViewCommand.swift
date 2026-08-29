//
//  SourceViewCommand.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

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

    /// Open new song
    case openNewSong(_: String)
    /// Insert a `Directive` at the cursor position
    case insertDirective(_: ChordPro.Directive)
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

    // MARK: Other

    /// Clear the current selection
    case clearSelection
    /// Schedule to update the song
    case updateSong
}

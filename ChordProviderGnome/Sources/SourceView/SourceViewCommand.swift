//
//  SourceViewCommand.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
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
    case openNewSong(String)
    /// Insert a `Directive` at the cursor position
    case insertDirective(ChordPro.Directive)
    /// Replace all text
    case replaceAllText(String)
    /// Append text to the end of the source
    case appendText(String)
    /// Replace all text on a specific line in the editor
    case replaceLineText(String)

    // MARK: Search commands

    /// Search
    case search(SourceViewBridge.SearchDirection)
    /// Replace match
    case replaceSearchMatch(with: String)
    /// Replace all matches
    case replaceAllSearchMatches(with: String)

    // MARK: Search options
    
    /// Use regular expressions
    case regularExpressions(Bool)
    /// Search must match whole words
    case matchWholeWordOnly(Bool)
    /// Search is case sensitive
    case caseSensitive(Bool)

    // MARK: Other

    /// Clear the current selection
    case clearSelection
    /// Schedule to update the song
    case updateSong
}

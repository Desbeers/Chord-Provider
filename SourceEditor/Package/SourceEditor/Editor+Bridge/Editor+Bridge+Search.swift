//
//  Editor+Bridge+search.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CGtkSourceView

extension Editor.Bridge {

    /// The state of the search for the bridge.
    struct Search {

        /// The search string.
        var search: String = ""
        /// The replacement string.
        var replace: String = ""
        /// Start of the current match.
        var matchStart = GtkTextIter()
        /// End of the current match.
        var matchEnd = GtkTextIter()
        /// The count of matches.
        var matchesCount = 0
        /// The index of the current match.
        var currentMatchIndex = 0
        /// Bool to show replace options.
        var showReplaceOptions: Bool = false

        // MARK: Search options.

        /// Bool to search with regular expressions.
        var regularExpressions: Bool = false
        /// Bool if search is case sensitive.
        var caseSensitive: Bool = false
        /// Bool if whole words should be matched.
        var matchWholeWordOnly: Bool = false

        // MARK: Calculated stuff.

        /// Bool if a match is active.
        var hasMatch: Bool {
            currentMatchIndex > 0
        }

        /// Display the counter result.
        var countDisplay: String {
            var result = ""
            if search.isEmpty || !haveMatches {
                // Don't display anything, the 'search field' will have a *warning* style
                return ""
            }
            if currentMatchIndex > 0 {
                result += "\(currentMatchIndex) of "
            }
            switch matchesCount {
            case 1:
                result += "1 match"
            default:
                result += "\(matchesCount) matches"
            }
            return result
        }

        /// Bool if there are matches.
        var haveMatches: Bool {
            matchesCount > 0
        }

        /// Bool if there are no matches.
        var noMatches: Bool {
            !search.isEmpty && !haveMatches
        }
    }

    /// The search direction.
    public enum SearchDirection: Sendable {
        /// Next match.
        case next
        /// Previous match.
        case previous
    }
}

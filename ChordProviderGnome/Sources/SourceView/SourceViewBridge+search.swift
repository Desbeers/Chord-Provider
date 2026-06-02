//
//  SourceViewBridge+search.swift
//  GtkSourceView
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import CSourceView
import ChordProviderCore

extension SourceViewBridge {

    /// The state of the search
    public struct SearchState: Sendable {
        /// Search
        public var search: String = ""
        /// Replace
        public var replace: String = ""
        /// Current match start
        var matchStart = GtkTextIter()
        /// Current match end
        var matchEnd = GtkTextIter()
        /// The count of matches
        public var matchesCount = 0
        /// The index of the current match index
        public var currentMatchIndex = 0
        /// Bool to show replace options
        public var showReplaceOptions: Bool = false

        // MARK: Search options

        public var regularExpressions: Bool = false
        public var caseSensitive: Bool = false
        public var matchWholeWordOnly: Bool = false

        // MARK: Calculated stuff

        /// Bool if a match is active
        public var hasMatch: Bool {
            currentMatchIndex > 0
        }

        /// Display the counter result
        public var countDisplay: String {
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

        /// Bool if there are matches
        public var haveMatches: Bool {
            matchesCount > 0
        }

        /// Bool if there are no matches
        public var noMatches: Bool {
            !search.isEmpty && !haveMatches
        }
    }

    /// The search direction
    public enum SearchDirection: Sendable {
        /// Next match
        case next
        /// Previous match
        case previous
    }
}

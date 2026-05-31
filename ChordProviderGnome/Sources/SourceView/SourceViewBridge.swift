//
//  SourceViewBridge.swift
//  GtkSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import CGtkSourceView

public struct SourceViewBridge: Equatable {

    /// Equatable protocol
    public static func == (lhs: SourceViewBridge, rhs: SourceViewBridge) -> Bool {
        lhs.currentLine == rhs.currentLine && lhs.song.content == rhs.song.content
    }

    /// The song
    public var song = Song(id: UUID(), content: "")

    /// The core settings
    public var coreSettings = ChordProviderSettings()

    /// The command for the editor
    public var command: SourceViewCommand?

    /// The current cursor line
    public var currentLine = Song.Section.Line()

    /// Bool if the editor is at the start of a line
    /// - Note: Used to check if 'insert' commands are available
    public var isAtBeginningOfLine: Bool = false

    /// All the lines in the song
    public var songLines = [Song.Section.Line]()

    /// Bool if the editor has a selection
    public var hasSelection: Bool = false

    /// Search
    public var search = SearchState()

    /// Show the *Edit directive* dialog
    public var showEditDirectiveDialog: Bool = false

    /// The directive to handle in the *Edit directive* dialog
    public var handleDirective: ChordPro.Directive?

    /// Init the bridge
    public init() {}
}

extension SourceViewBridge: Codable {

    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case coreSettings
    }
}

extension SourceViewBridge {

    /// The state of the search
    public struct SearchState {
        /// Search
        public var search: String = ""
        /// Replace
        public var replace: String = ""
        /// Current search position
        var currentIter = GtkTextIter()
        /// Current match start
        var matchStart = GtkTextIter()
        /// Current match end
        var matchEnd = GtkTextIter()
        /// The count of matches
        public var matchesCount = 0
        /// Bool to show replace options
        public var showReplaceOptions: Bool = false

        // MARK: Search options

        public var regularExpressions: Bool = false
        public var caseSensitive: Bool = false
        public var matchWholeWordOnly: Bool = false

        // MARK: Calculated stuff

        /// Bool if a match is active
        public var hasMatch: Bool {
            var start = matchStart
            var end = matchEnd
            //return gtk_text_iter_compare(&start, &end) != 0
            return gtk_text_iter_equal(&start, &end) == 0
        }

        public var matchDisplay: String {
            if search.isEmpty || !haveMatches {
                return ""
            }
            switch matchesCount {
                case 1:
                    return "1 match"
                default:
                    return "\(matchesCount) matches"
            }
        }

        public var noResultsFound: Bool {
            !search.isEmpty && !haveMatches
        }

        /// Bool if there are matches
        public var haveMatches: Bool {
            matchesCount > 0 ? true : false
        }
    }

    /// The search direction
    public enum SearchDirection {
        /// Next result
        case next
        /// Previous result
        case previous
    }
}
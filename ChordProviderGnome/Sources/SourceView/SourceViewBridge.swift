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

        public var matchDisplay: String {
            var result = ""
            if search.isEmpty || !haveMatches {
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

        public var noResultsFound: Bool {
            !search.isEmpty && !haveMatches
        }

        /// Bool if there are matches
        public var haveMatches: Bool {
            matchesCount > 0
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
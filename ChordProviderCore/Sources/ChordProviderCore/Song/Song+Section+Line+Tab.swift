//
//  Song+Section+Line+Tab.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    public struct Tab: Identifiable, Equatable, Codable, Sendable {
        /// Init
        public init(lineID: Int, plain: String, events: [Event] = []) {
            self.lineID = lineID
            self.plain = plain
            self.events = events
        }
        /// Identifiable protocol
        public var id: Int {
            lineID
        }
        /// Plain tab line
        public let plain: String
        /// The line ID
        public let lineID: Int
        /// The events in the column of the tab
        public var events: [Event] = []
    }
}

extension Song.Section.Line.Tab {

    /// The event of a tab
    public struct Event: Identifiable, Equatable, Codable, Sendable {
        /// Identifiable protocol
        public var id: Int {
            column
        }
        /// The column of the tab event
        public let column: Int
        /// The content of the tab event
        public let content: Content
        public var startIndex: Int = 0
        public var endIndex: Int = 0
    }

    /// The content of the tab
    public enum Content: Codable, Sendable, Equatable {
        /// Just plain text
        case text(String)
        /// A rest
        case rest(display: String)
        /// A barLine
        case barLine
        /// A fret
        case fret(display: String, note:Int)
        /// A note transition
        case transition(display: String, from: Int, to: Int, transition: ChordPro.Tab.NoteTransition)
        /// A filler
        case filler

        /// Bool if the content has a transition
        public var hasFiller: Bool {
            if case .filler = self { true } else { false }
        }

        /// Bool if the content has a playable item
        public var hasPlayableItem: Bool {
            switch self {
            case .rest, .fret, .transition:
                true
            default:
                false
            }
        }

        /// Bool if the content has a note item
        public var hasNoteItem: Bool {
            switch self {
            case .fret, .transition:
                true
            default:
                false
            }
        }
    }
}

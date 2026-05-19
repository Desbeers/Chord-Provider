//
//  Song+Section+Line+Tab.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {
    
    public struct Tab: Identifiable, Equatable, Codable, Sendable {
        /// Identifiable protocol
        public var id: Int {
            columnID
        }
        /// The instrument
        public let instrument: Instrument
        /// The column ID
        public let columnID: Int
        /// The events in the column of the tab
        public let events: [Event]
    }
}

extension Song.Section.Line.Tab {

    /// The event of a tab
    public struct Event: Identifiable, Equatable, Codable, Sendable {
        /// Identifiable protocol
        public var id: Int {
            line
        }
        /// The line of the tab event
        public let line: Int
        /// The content of the tab event
        public let content: Content
    }

    /// The content of the tab
    public enum Content: Codable, Sendable, Equatable {
        /// Just plain text
        case text(String)
        /// A rest
        case rest
        /// A barLine
        case barLine
        /// A fret
        case fret(Int)
        /// A note transition
        case transition(from: Int, to: Int, transition: ChordPro.Tab.NoteTransition)

        /// Bool if the content has a transition
        public var hasTransition: Bool {
            if case .transition = self { true } else { false }
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
    }
}

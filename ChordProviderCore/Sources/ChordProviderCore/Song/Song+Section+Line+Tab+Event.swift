//
//  Song+Section+Line+Tab+Event.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

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
        public var content: Content
        /// The optional transition note
        public var transitionNote: Int? = nil
        /// The start index of the event
        public var startIndex: Int = 0
        /// The end index of the event
        public var endIndex: Int = 0
    }
}

extension Song.Section.Line.Tab.Event {

    /// The content of the tab
    public enum Content: Codable, Sendable, Equatable {
        /// Just plain text
        case text
        /// A rest
        case rest
        /// A barLine
        case barLine
        /// A fret
        case fret(note:Int)
        /// A note transition
        case transition(transition: ChordPro.Tab.Transition)
        /// A filler
        case filler

        /// Bool if the content has a transition
        public var hasFiller: Bool {
            if case .filler = self { true } else { false }
        }
        
        /// Bool if the content has a rest
        public var hasRest: Bool {
            if case .rest = self { true } else { false }
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
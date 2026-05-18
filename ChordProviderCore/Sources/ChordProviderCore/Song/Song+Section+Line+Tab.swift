//
//  Song+Section+Line+Tab.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {
    
    public struct Tab: Identifiable, Equatable, Codable, Sendable {

        public var id: Int {
            tick
        }

        public let tick: Int
        public let events: [Event]
    }
}
 
extension Song.Section.Line.Tab {

    public struct Event: Identifiable, Equatable, Codable, Sendable {
        public var id: Int {
            string
        }
        public let string: Int
        public let content: Content
    }

    public enum SlideDirection: Codable, Sendable {
        case up
        case down

        public var display: String{
            switch self {
                case .up: "/"
                case .down: "\\"
            }
        }
    }

    public enum Content: Codable, Sendable, Equatable {
        case text(String)
        case rest
        case barLine
        case fret(Int)
        case slide(from: Int, to: Int, direction: SlideDirection)

        /// Bool if the content has a slide
        public var hasSlide: Bool {
            if case .slide = self { true } else { false }
        }

        /// Bool if the content has a playable item
        public var hasPlayableItem: Bool {
            switch self {
            case .rest, .fret, .slide:
                true
            default:
                false
            }
        }
    }
}

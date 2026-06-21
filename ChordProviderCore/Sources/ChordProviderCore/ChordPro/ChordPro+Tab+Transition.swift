//
//  ChordPro+Tab+Transition.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation


extension ChordPro.Tab {

    public struct Transition: Sendable, Codable, Equatable {

        /// A transition from one MIDI note to another
        /// - Parameters:
        ///   - from: The start note
        ///   - to: The end note
        ///   - by: The kind of transition
        public init(
            from: Int,
            to: Int,
            by: Technique
        ) {
            self.from = from
            self.to = to
            self.technique = by
        }
        /// The start note
        public let from: Int
        /// The end note
        public let to: Int
        /// The kind of transition
        public let technique: Technique
    }
}

extension ChordPro.Tab.Transition {

    /// The transition technique
    public enum Technique: String, Sendable, Codable {
        /// Slide a note
        case slide
        /// Slide a note up
        case slideUp
        /// Slide a note down
        case slideDown
        /// Hammer a note
        case hammerOn
        /// Pull-off a note
        case pullOff
        /// Bend a note up
        case bendUp
        /// Release a bended note
        case releaseBend

        /// Display 
        public var display: String {
            switch self {
            case .slide: "s"
            case .slideUp: "/"
            case .slideDown: "\\"
            case .hammerOn: "h"
            case .pullOff: "p"
            case .bendUp: "b"
            case .releaseBend: "r"
            }
        }

        /// Convert a transition character to a technique Enum
        public static var characterDictionary: [String: Self] {
            [
                "s": .slide,
                "/": .slideUp,
                "\\": .slideDown,
                "h": .hammerOn,
                "p": .pullOff,
                "b": .bendUp,
                "r": .releaseBend
            ]
        }
    }
}

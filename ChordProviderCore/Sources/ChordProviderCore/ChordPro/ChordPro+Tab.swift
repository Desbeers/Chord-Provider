//
// ChordPro+Tab.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// Stuff that can be part of a *Tab* 
    public enum Tab {
        // Just a placeholder
    }

}

extension ChordPro.Tab {

    public struct Transition: Sendable, Codable, Equatable {
        public let from: Int
        public let to: Int
        public let technique: Technique
    }

    public enum Technique: String, Sendable, Codable {
        case slide
        case slideUp
        case slideDown
        case hammerOn
        case pullOff
        case bendUp
        case releaseBend

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

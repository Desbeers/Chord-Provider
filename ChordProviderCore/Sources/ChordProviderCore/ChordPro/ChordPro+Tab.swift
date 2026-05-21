//
// ChordPro+Tab.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordPro {

    /// Stuff that can be part of a *Tab* 
    public enum Tab {
        // Just a placeholder
    }

}

extension ChordPro.Tab {

    public enum NoteTransition: String, Sendable, Codable {
        case slide
        case slideUp
        case slideDown
        case hammerOn
        case pullOff

        public var display: String {
            switch self {
            case .slide: "s"
            case .slideUp: "/"
            case .slideDown: "\\"
            case .hammerOn: "h"
            case .pullOff: "p"
            }
        }

        public static var characterDictionary: [String: Self] {
            [
                "s": .slide,
                "/": .slideUp,
                "\\": .slideDown,
                "h": .hammerOn,
                "p": .pullOff
            ]
        }
    }
}

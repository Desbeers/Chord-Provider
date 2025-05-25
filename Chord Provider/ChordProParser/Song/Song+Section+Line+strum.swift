//
//  Song+Section+Line+Strum.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    /// The structure of a strum
    struct Strum: Equatable, Codable, Identifiable, Hashable {
        /// The ID
        var id: Int = 0
        /// The strum action
        var action: Action = .none
        /// The beat symbol
        var beat: String = ""
        /// The tuplet symbol
        var tuplet: String = "&"
        /// Optional top symbol
        var topSymbol: String {
            switch self.action {
            case .accentedUp, .accentedDown:
                ">"
            case .mutedUp, .mutedDown:
                "x"
            default:
                " "
            }
        }
    }

    /// Convert strum characters in the source to fancy symbols
    static var strumCharacterDict: [String: Song.Section.Line.Strum.Action] {
        [
            "u": .up,
            "up": .up,
            "ua": .accentedUp,
            "um": .mutedUp,
            "us": .slowUp,
            "d": .down,
            "dn": .down,
            "da": .accentedDown,
            "dm": .mutedDown,
            "ds": .slowDown,
            "x": .palmMute,
            ".": .none
        ]
    }
}

extension Song.Section.Line.Strum {

    /// The strum actions
    enum Action: Codable {
        /// Up stroke
        case up
        /// Accented up stroke
        case accentedUp
        /// Muted up stroke
        case mutedUp
        /// Slow up stroke
        case slowUp
        /// Down stroke
        case down
        /// Accented down stroke
        case accentedDown
        /// Muted down stroke
        case mutedDown
        /// Slow down stroke
        case slowDown
        /// Palm mute stroke
        case palmMute
        /// Do not stroke
        case none
    }
}

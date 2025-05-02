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
        /// The strum symbol
        var strum: String = ""
        /// The beat symbol
        var beat: String = ""
        /// The tuplet symbol
        var tuplet: String = ""
    }

    /// Convert strum characters in the source to fancy symbols
    static var strumCharacterDict: [String: String] {
        [
            "u": "↑",
            "d": "↓",
            "x": "ⅹ",
            ".": "."
        ]
    }
}

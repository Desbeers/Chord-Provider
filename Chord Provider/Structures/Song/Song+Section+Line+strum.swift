//
//  Song+Section+Line+Strum.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

    struct Strum: Equatable, Codable, Identifiable, Hashable {
        var id: Int = 0
        var strum: String = ""
        var beat: String = ""
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

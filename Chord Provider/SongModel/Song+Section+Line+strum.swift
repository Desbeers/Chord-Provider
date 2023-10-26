//
//  Song+Section+Line+strum.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Song.Section.Line {

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

//
//  ChordProFormatter.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//
// Many thanks for https://github.com/dbarsamian/conscriptor

import Foundation

struct ChordProFormatter {
    /// Enumeration of supported syntax that can be formatted by the ChordProFormatter.
    enum Formatting: String, CaseIterable {
        case chorus = "{soc}\n"
        case verse = "{sov}\n"
        case comment = "{comment: "
        /// The start of the format
        var start: String {
            self.rawValue
        }
        /// The end of the format
        var end: String {
            switch self {
            case .chorus:
                return "\n{eoc}\n"
            case .verse:
                return "\n{eov}\n"
            case .comment:
                return "}"
            }
        }
    }

    /// Returns a string that has been reformatted based on the given ChordPro style.
    /// - Parameter string: The string to format.
    /// - Parameter style: The ChordPro syntax to apply or remove.
    static func format(_ string: String, style: Formatting) -> String {
        dump(string)
        var formattedString = ""
            formattedString = string
            formattedString.insert(contentsOf: style.start, at: formattedString.startIndex)
            formattedString.append(style.end)
        return formattedString
    }
}

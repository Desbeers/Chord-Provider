//
//  EditorView+regex.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 18/06/2023.
//

import Foundation

extension EditorView {

    /// All the directives we know about
    static var directives: String {
        var directives: [String] = []
        for item in ChordPro.Directive.allCases {
            directives.append("\\{\(item.rawValue)")
        }
        return directives.joined(separator: "|")
    }
    /// The regex for a chord, [Am] for example
    static let chordRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]", options: .caseInsensitive)
    /// The regex for directives
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{.*\\}")
    /// The regex for a directive value we know about
    static let directiveValueRegex = try? NSRegularExpression(pattern: "(?:" + directives + ")\\b", options: [])
    /// The regex for the end of a directive
    static let directiveEndRegex = try? NSRegularExpression(pattern: "\\}")
}

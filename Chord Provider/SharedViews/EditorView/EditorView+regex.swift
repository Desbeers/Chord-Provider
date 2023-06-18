//
//  EditorView+regex.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 18/06/2023.
//

import Foundation

extension EditorView {

    /// The regex for a chord, [Am] for example
    static let chordRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    /// The regex for directives with a value, {title: lalala} for example
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([[^}]]*)\\}")
    /// The regex for directives without a value, {soc} for example
    static let emptyDirectiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
}

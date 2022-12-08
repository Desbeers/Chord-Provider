//
//  Editor+Regex.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Editor {

    /// The regex for directives with a value, {title: lalala} for example
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([[^}]]*)\\}")
    /// The regex for directives without a value, {soc} for example
    static let directiveEmptyRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
    /// The regex for chord define
    static let defineRegex = try? NSRegularExpression(pattern: "([a-z0-9#b/]+)(.*)", options: .caseInsensitive)
    /// The regex for a 'normal'  line
    static let lineRegex = try? NSRegularExpression(pattern: "(\\[[\\w#b/]+])?([^\\[]*)", options: .caseInsensitive)
    /// The regex for a chord (used in the text editor for macOS)
    static let chordsRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
}

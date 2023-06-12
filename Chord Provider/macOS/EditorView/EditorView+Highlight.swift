//
//  EditorView+Highlights.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import AppKit
import HighlightedTextEditor

extension EditorView {

    /// The regex for a chord, [Am] for example
    static let chordRegex = try? NSRegularExpression(pattern: "\\[([\\w#b\\/]+)\\]?", options: .caseInsensitive)
    /// The regex for directives with a value, {title: lalala} for example
    static let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([[^}]]*)\\}")
    /// The regex for directives without a value, {soc} for example
    static let emptyDirectiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*)\\}")
}

extension EditorView {

    /// The highlight rules
    static let rules: [HighlightRule] = [
        HighlightRule(pattern: EditorView.chordRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.red)
        ]),
        HighlightRule(pattern: EditorView.directiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.systemBlue)
        ]),
        HighlightRule(pattern: EditorView.emptyDirectiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: NSColor.systemBlue)
        ]),
        HighlightRule(pattern: NSRegularExpression.all, formattingRules: [
            TextFormattingRule(key: .font, value: NSFont(name: "Andale Mono", size: 16)!)
        ])
    ]
}

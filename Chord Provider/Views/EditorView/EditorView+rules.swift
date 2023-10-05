//
//  EditorView+Highlights.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//
import HighlightedTextEditor

#if os(macOS)
import AppKit
/// Alias for NSColor
typealias SWIFTColor = NSColor
/// Alias for NSFont
typealias SWIFTFont = NSFont
#endif

#if os(iOS)
import UIKit
/// Alias for UIColor
typealias SWIFTColor = UIColor
/// Alias for UIFont
typealias SWIFTFont = UIFont
#endif

extension EditorView {

    /// The highlight rules
    static let rules: [HighlightRule] = [
        /// The rule for all lines
        HighlightRule(pattern: NSRegularExpression.all, formattingRules: [
            TextFormattingRule(key: .paragraphStyle, value: nsParagraphStyle)
        ]),
        /// The rule for a chord
        HighlightRule(pattern: EditorView.chordRegex, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemRed)
        ]),
        /// The rule for a directive
        HighlightRule(pattern: EditorView.directiveRegex, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemTeal)
        ]),
        /// The rule for the value of a directive
        HighlightRule(pattern: EditorView.directiveValueRegex, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue)
        ]),
        /// The rule for the end of directive
        HighlightRule(pattern: EditorView.directiveEndRegex, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue)
        ])
    ]

    /// The style of a paragraph in the editor
    static let nsParagraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.5
        style.headIndent = 10
        return style
    }()
}

//
//  EditorView+Highlights.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//
import HighlightedTextEditor

#if os(macOS)
import AppKit
typealias SWIFTColor = NSColor
typealias SWIFTFont = NSFont
#endif

#if os(iOS)
import UIKit
typealias SWIFTColor = UIColor
typealias SWIFTFont = UIFont
#endif

extension EditorView {

    /// The highlight rules
    static let rules: [HighlightRule] = [
        /// The rue for all lines
        HighlightRule(pattern: NSRegularExpression.all, formattingRules: [
            TextFormattingRule(key: .font, value: font(weight: .light)),
            TextFormattingRule(key: .paragraphStyle, value: nsParagraphStyle)
        ]),
        /// The rule for a chord
        HighlightRule(pattern: EditorView.chordRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemRed)
        ]),
        /// The rule for a directive
        HighlightRule(pattern: EditorView.directiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemTeal),
            TextFormattingRule(key: .font, value: font(weight: .medium))
        ]),
        /// The rule for the value of a directive
        HighlightRule(pattern: EditorView.directiveValueRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue),
        ]),
        /// The rule for the end of directive
        HighlightRule(pattern: EditorView.directiveEndRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue),
        ])
    ]

    /// The style of a paragraph in the editor
    static let nsParagraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        style.headIndent = 10
        return style
    }()

    /// The font for a line in the editor
    /// - Parameter weight: The weight of a font
    /// - Returns: A font declaration
    static func font(weight: SWIFTFont.Weight) -> SWIFTFont {
        return SWIFTFont.monospacedSystemFont(ofSize: 14, weight: weight)
    }
}

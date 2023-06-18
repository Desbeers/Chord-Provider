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
        HighlightRule(pattern: EditorView.chordRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.red)
        ]),
        HighlightRule(pattern: EditorView.directiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue)
        ]),
        HighlightRule(pattern: EditorView.emptyDirectiveRegex!, formattingRules: [
            TextFormattingRule(key: .foregroundColor, value: SWIFTColor.systemBlue)
        ]),
        HighlightRule(pattern: NSRegularExpression.all, formattingRules: [
            TextFormattingRule(key: .font, value: SWIFTFont.monospacedSystemFont(ofSize: 14, weight: .light)),
            TextFormattingRule(key: .paragraphStyle, value: nsParagraphStyle)
        ])
    ]

    /// The style of a paragraph in the editor
    static let nsParagraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.2
        return style
    }()
}

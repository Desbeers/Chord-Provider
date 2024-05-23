//
//  ChordProEditor+Static.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    /// The lineheight multiplier for the editpr text
    static let lineHeightMultiple: Double = 1.2

    /// The style of a paragraph in the editor
    static let paragraphStyle: NSParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = ChordProEditor.lineHeightMultiple
        style.headIndent = 10
        return style
    }()

    /// The style of a number in the ruler
    static var rulerNumberStyle: StringAttributes {
        let lineNumberStyle = NSMutableParagraphStyle()
        lineNumberStyle.alignment = .right
        lineNumberStyle.lineHeightMultiple = lineHeightMultiple
        var fontAttributes: StringAttributes = [:]
        fontAttributes[NSAttributedString.Key.paragraphStyle] = lineNumberStyle
        fontAttributes[NSAttributedString.Key.backgroundColor] = SWIFTColor.clear
        fontAttributes[NSAttributedString.Key.foregroundColor] = highlightedForegroundColor

        return fontAttributes
    }

    /// The style of a symbol in the ruler
    static var rulerSymbolStyle: StringAttributes {
        let lineNumberStyle = NSMutableParagraphStyle()
        lineNumberStyle.alignment = .right
        lineNumberStyle.lineHeightMultiple = lineHeightMultiple
        var fontAttributes: StringAttributes = [:]
        fontAttributes[NSAttributedString.Key.paragraphStyle] = lineNumberStyle
        fontAttributes[NSAttributedString.Key.backgroundColor] = SWIFTColor.clear
        fontAttributes[NSAttributedString.Key.foregroundColor] = highlightedForegroundColor

        return fontAttributes
    }

    /// The foreground of the highlighted line in the editor
    static let highlightedForegroundColor: SWIFTColor = .textColor.withAlphaComponent(0.3)

    /// The background of the highlighted line in the editor
    static let highlightedBackgroundColor: SWIFTColor = .textColor.withAlphaComponent(0.03)
}

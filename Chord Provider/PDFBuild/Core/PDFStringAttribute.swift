//
//  PDFStringAttribute.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// Alias for a `NSAttributedString` key and value
typealias PDFStringAttribute = [NSAttributedString.Key: Any]

extension PDFStringAttribute {

    // MARK: Merge stylings

    /// Merge ``PDFStringAttribute``'s
    /// - Parameters:
    ///   - left: Current ``PDFStringAttribute``
    ///   - right: The ``PDFStringAttribute`` to add
    /// - Returns: The merged ``PDFStringAttribute``'s
    static func + (left: PDFStringAttribute, right: PDFStringAttribute) -> PDFStringAttribute {
        var left = left
        for element in right {
            left[element.key] = element.value
        }
        return left
    }

    // MARK: General string styling

    /// - Note: Element specific styling is in its own file

    /// Style attributes for a slightly smaller text font
    static func smallTextFont(settings: AppSettings) -> PDFStringAttribute {
        [
            .foregroundColor: settings.style.theme.foreground.nsColor,
            .font: NSFont(name: settings.style.fonts.text.font.postScriptName, size: settings.style.fonts.text.size * 0.8) ?? NSFont.systemFont(ofSize: 8)
        ]
    }

    // MARK: String alignment styling

    /// Style attributes for alignment of a paragraph
    /// - Parameter alignment: The alignment
    /// - Returns: A paragraph alignment style
    static func alignment(_ alignment: NSTextAlignment) -> PDFStringAttribute {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return [.paragraphStyle: style]
    }
}

extension PDFStringAttribute {

    /// Style attribute for the selected foreground color
    /// - Parameter settings: The ``AppSettings``
    /// - Returns: The ``PDFStringAttribute`` with the foreground color
    static func foregroundColor(settings: AppSettings) -> PDFStringAttribute {
        [
            .foregroundColor: settings.style.theme.foreground.nsColor
        ]
    }


    /// Style attributes for a ``FontConfig``
    /// - Parameters:
    ///   - config: The ``FontConfig``
    ///   - settings: The ``AppSettings``
    /// - Returns: The ``PDFStringAttribute`` with the font and color
    static func attributes(_ config: FontConfig, settings: AppSettings, scale: Double = 1) -> PDFStringAttribute {
        var font = NSFont()
        var color = NSColor()
        let settings = settings.style
        switch config {
        case .title:
            font = settings.fonts.title.nsFont(scale: scale)
            color = settings.theme.foreground.nsColor
        case .subtitle:
            font = settings.fonts.subtitle.nsFont(scale: scale)
            color = settings.theme.foregroundMedium.nsColor
        case .text:
            font = settings.fonts.text.nsFont(scale: scale)
            color = settings.theme.foreground.nsColor
        case .chord:
            font = settings.fonts.chord.nsFont(scale: scale)
            color = settings.fonts.chord.color.nsColor
        case .label:
            font = settings.fonts.label.nsFont(scale: scale)
            color = settings.fonts.label.color.nsColor
        case .comment:
            font = settings.fonts.comment.nsFont(scale: scale)
            color = settings.fonts.comment.color.nsColor
        case .tag:
            font = settings.fonts.tag.nsFont(scale: scale)
            color = settings.fonts.tag.color.nsColor
        case .textblock:
            font = settings.fonts.textblock.nsFont(scale: scale)
            color = settings.fonts.textblock.color.nsColor
        }
        return [
            .font: font,
            .foregroundColor: color
        ]
    }
}

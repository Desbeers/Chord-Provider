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

    /// Style attributes for the default font
//    static var defaultFont: PDFStringAttribute {
//        [
//            .foregroundColor: NSColor.black,
//            .font: NSFont.systemFont(ofSize: 10, weight: .regular)
//        ]
//    }

    /// Style attributes for the small font
    static var smallFont: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }

    /// Style attributes for the title of the PDF
    static func pdfTitle(settings: AppSettings.PDF) -> PDFStringAttribute {
        [
            .foregroundColor: NSColor(settings.theme.foreground),
            .font: NSFont.systemFont(ofSize: 14, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style attributes for the subtitle of the PDF
    static func pdfSubtitle(settings: AppSettings.PDF) -> PDFStringAttribute {
        [
            .foregroundColor: NSColor(settings.theme.foregroundMedium),
            .font: NSFont.systemFont(ofSize: 12, weight: .regular)
        ] + .alignment(.center)
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

    static func foregroundColor(settings: AppSettings.PDF) -> PDFStringAttribute {
        [
            .foregroundColor: NSColor(settings.theme.foreground)
        ]
    }


    static func attributes(_ config: ChordPro.FontConfig, settings: AppSettings.PDF) -> PDFStringAttribute {
        var font = NSFont()
        var color = NSColor()
        switch config {
        case .title:
            font = settings.fonts.title.nsFont
            color = NSColor(settings.theme.foreground)
        case .subtitle:
            font = settings.fonts.subtitle.nsFont
            color = NSColor(settings.theme.foregroundMedium)
        case .text:
            font = settings.fonts.text.nsFont
            color = NSColor(settings.theme.foreground)
        case .chord:
            font = settings.fonts.chord.nsFont
            color = NSColor(settings.fonts.chord.color)
        case .label:
            font = settings.fonts.label.nsFont
            color = NSColor(settings.fonts.label.color)
        case .comment:
            font = settings.fonts.comment.nsFont
            color = NSColor(settings.fonts.comment.color)
        }
        return [
            .font: font,
            .foregroundColor: color
        ]
    }
}

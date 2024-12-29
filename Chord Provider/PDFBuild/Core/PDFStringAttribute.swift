//
//  PDFStringAttribute.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

/// Alias for a `NSAttributedString` key and value
typealias PDFStringAttribute = [NSAttributedString.Key: Any]

extension PDFStringAttribute {

    // MARK: Merge stylings

    /// Merge ``StringAttributes``
    /// - Parameters:
    ///   - left: Current ``StringAttributes``
    ///   - right: The ``StringAttributes`` to add
    /// - Returns: The merged ``StringAttributes``
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
    static var defaultFont: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    /// Style attributes for the small font
    static var smallFont: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }

    /// Style attributes for the title of the PDF
    static var pdfTitle: PDFStringAttribute {
        [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 14, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style attributes for the subtitle of the PDF
    static var pdfSubtitle: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray,
            .font: NSFont.systemFont(ofSize: 12, weight: .regular)
        ] + .alignment(.center)
    }

    /// Style attributes for the export title
    static var exportTitle: PDFStringAttribute {
        [
            .foregroundColor: NSColor.white,
            .font: NSFont.systemFont(ofSize: 28, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style attributes for the export author
    static var exportAuthor: PDFStringAttribute {
        [
            .foregroundColor: NSColor.gray,
            .font: NSFont.systemFont(ofSize: 24, weight: .regular)
        ] + .alignment(.center)
    }

    // MARK: String alignment styling

    /// Style attributes for alignment of a paragraph
    /// - Parameter alignment: The alignment
    /// - Returns: A paragraph aligment style
    static func alignment(_ alignment: NSTextAlignment) -> PDFStringAttribute {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return [.paragraphStyle: style]
    }

    // MARK: Serif font string styling

    /// Style attributes for a *serif* font style
    static var serifFont: PDFStringAttribute {
        let descriptor = NSFontDescriptor
            .preferredFontDescriptor(
                forTextStyle: .body
            )
            .withDesign(.serif)
        return [.font: NSFont(descriptor: descriptor ?? NSFontDescriptor(), size: 10) ?? [:]]
    }
}

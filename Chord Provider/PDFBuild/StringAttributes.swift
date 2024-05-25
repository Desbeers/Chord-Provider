//
//  StringAttributes.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension SWIFTStringAttribute {

    // MARK: Merge stylings

    /// Merge ``StringAttributes``
    /// - Parameters:
    ///   - left: Current ``StringAttributes``
    ///   - right: The ``StringAttributes`` to add
    /// - Returns: The merged ``StringAttributes``
    static func + (left: SWIFTStringAttribute, right: SWIFTStringAttribute) -> SWIFTStringAttribute {
        var left = left
        for element in right {
            left[element.key] = element.value
        }
        return left
    }

    // MARK: General string styling

    /// - Note: Element specific styling is in its own file

    /// Style attributes for the default font
    static var defaultFont: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    /// Style attributes for the small font
    static var smallFont: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }

    /// Style attributes for the title of the song
    static var songTitle: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 14, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style attributes for the artist of the song
    static var songArtist: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 12, weight: .regular)
        ] + .alignment(.center)
    }

    /// Style attributes for the export title
    static var exportTitle: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.white,
            .font: SWIFTFont.systemFont(ofSize: 28, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style attributes for the export author
    static var exportAuthor: SWIFTStringAttribute {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 24, weight: .regular)
        ] + .alignment(.center)
    }

    // MARK: String alignment styling

    /// Style attributes for alignment of a paragraph
    /// - Parameter alignment: The alignment
    /// - Returns: A paragraph aligment style
    static func alignment(_ alignment: NSTextAlignment) -> SWIFTStringAttribute {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return [.paragraphStyle: style]
    }

    // MARK: Serif font string styling

    /// Style attributes for a *serif* font style
    static var serifFont: SWIFTStringAttribute {
#if os(macOS)
        let descriptor = NSFontDescriptor
            .preferredFontDescriptor(
                forTextStyle: .body
            )
            .withDesign(.serif)
        return [.font: SWIFTFont(descriptor: descriptor ?? NSFontDescriptor(), size: 10) ?? [:]]
#else
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(
                withTextStyle: .body
            )
            .withDesign(.serif)
        return [.font: SWIFTFont(descriptor: descriptor ?? UIFontDescriptor(), size: 10)]
#endif
    }
}

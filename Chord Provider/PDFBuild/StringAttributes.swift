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

public extension StringAttributes {

    /// Merge ``StringAttributes``
    /// - Parameters:
    ///   - left: Current ``StringAttributes``
    ///   - right: The ``StringAttributes`` to add
    /// - Returns: The merged ``StringAttributes``
    static func + (left: StringAttributes, right: StringAttributes) -> StringAttributes {
        var left = left
        for element in right {
            left[element.key] = element.value
        }
        return left
    }

    // MARK: General string styling

    /// - Note: Element specific styling is in its own file

    /// Style atributes for the default font
    static var defaultFont: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    /// Style atributes for the small font
    static var smallFont: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }

    /// Style atributes for the title of the song
    static var songTitle: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 14, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style atributes for the artist of the song
    static var songArtist: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 12, weight: .regular)
        ] + .alignment(.center)
    }

    /// Style atributes for the export title
    static var exportTitle: StringAttributes {
        [
            .foregroundColor: SWIFTColor.white,
            .font: SWIFTFont.systemFont(ofSize: 28, weight: .semibold)
        ] + .alignment(.center)
    }

    /// Style atributes for the export author
    static var exportAuthor: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 24, weight: .regular)
        ] + .alignment(.center)
    }

    // MARK: String alignment styling

    /// Style atributes for alignment of a paragraph
    /// - Parameter alignment: The alignment
    /// - Returns: A paragraph aligment style
    static func alignment(_ alignment: NSTextAlignment) -> StringAttributes {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return [.paragraphStyle: style]
    }

    // MARK: Serif font string styling

    /// Style atributes for a *serif* font style
    static var serifFont: StringAttributes {
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

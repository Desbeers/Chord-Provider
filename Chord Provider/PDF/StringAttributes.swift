//
//  StringAttributes.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public typealias StringAttributes = [NSAttributedString.Key: Any]

public extension StringAttributes {

    static func + (left: StringAttributes, right: StringAttributes) -> StringAttributes {
        var left = left
        for element in right {
            left[element.key] = element.value
        }
        return left
    }
}

// MARK: General string styling

/// - Note: Element specific styling is in its own file

public extension StringAttributes {

    static var defaultFont: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }

    static var smallFont: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 6, weight: .regular)
        ]
    }

    static var songTitle: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 14, weight: .semibold)
        ] + .alignment(.center)
    }

    static var songArtist: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 12, weight: .regular)
        ] + .alignment(.center)
    }

    static func alignment(_ alignment: NSTextAlignment) -> StringAttributes {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        return [.paragraphStyle: style]
    }
}

// MARK: Serif font string styling

public extension StringAttributes {

    // swiftlint:disable force_unwrapping
    static var serifFont: StringAttributes {
#if os(macOS)
        let descriptor = NSFontDescriptor
            .preferredFontDescriptor(
                forTextStyle: .body
            )
            .withDesign(.serif)!
        return [.font: SWIFTFont(descriptor: descriptor, size: 10)!]
#else
        let descriptor = UIFontDescriptor
            .preferredFontDescriptor(
                withTextStyle: .body
            )
            .withDesign(.serif)!
        return [.font: SWIFTFont(descriptor: descriptor, size: 10)]
#endif
    }
    // swiftlint:enable force_unwrapping
}

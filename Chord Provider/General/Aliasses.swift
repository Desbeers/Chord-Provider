//
//  Aliasses.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(macOS)

// MARK: macOS typealiases

/// Alias for NSImage
public typealias SWIFTImage = NSImage
/// Alias for NSColor
public typealias SWIFTColor = NSColor
/// Alias for NSFont
public typealias SWIFTFont = NSFont
/// Alias for NSTextView
public typealias SWIFTTextView = NSTextView
/// Alias for NSEdgeInsets
public typealias SWIFTEdgeInsets = NSEdgeInsets
/// Alias for NSBezierPath
public typealias SWIFTBezierPath = NSBezierPath

// MARK: macOS extensions

extension NSBezierPath {
    convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
}

public extension NSImage {
    convenience init(systemName: String) {
        // swiftlint:disable:next force_unwrapping
        self.init(systemSymbolName: systemName, accessibilityDescription: nil)!
    }
}

extension NSFont {

    static func italicSystemFont(ofSize fontSize: CGFloat) -> NSFont {
        let systemFont = NSFont.systemFont(ofSize: fontSize)

        // Create a font descriptor with the italic trait
        let fontDescriptor = systemFont.fontDescriptor.withSymbolicTraits(.italic)

        // Create a font from the descriptor
        let italicSystemFont = NSFont(descriptor: fontDescriptor, size: fontSize)

        return italicSystemFont ?? systemFont // Return italic font or fallback to system font
    }
}

extension NSRect {
    func inset(by insets: NSEdgeInsets) -> NSRect {
        var rect = self
        rect.origin.x += insets.left
        rect.origin.y += insets.top
        rect.size.width -= (insets.left + insets.right)
        rect.size.height -= (insets.top + insets.bottom)
        return rect
    }
}

#else

// MARK: iOS typealiases

/// Alias for UIImage
public typealias SWIFTImage = UIImage
/// Alias for UIColor
public typealias SWIFTColor = UIColor
/// Alias for SWIFTFont
public typealias SWIFTFont = UIFont
/// Alias for UITextView
public typealias SWIFTTextView = UITextView
/// Alias for UIEdgeInsets
public typealias SWIFTEdgeInsets = UIEdgeInsets
/// Alias for UIBezierPath
public typealias SWIFTBezierPath = UIBezierPath

// MARK: macOS extensions

extension NSString {
    typealias DrawingOptions = NSStringDrawingOptions
}

#endif

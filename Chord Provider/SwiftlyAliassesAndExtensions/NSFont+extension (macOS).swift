//
//  NSFont+extension (macOS).swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)

import AppKit

extension NSFont {

    /// Create an italic font
    /// - Parameter fontSize: The size of the font
    /// - Returns: An `NSFont`
    ///
    /// - Note: Not used in **Chord Provider**
    static func italicSystemFont(ofSize fontSize: CGFloat) -> NSFont {
        let systemFont = NSFont.systemFont(ofSize: fontSize)

        /// Create a font descriptor with the italic trait
        let fontDescriptor = systemFont.fontDescriptor.withSymbolicTraits(.italic)

        /// Create a font from the descriptor
        let italicSystemFont = NSFont(descriptor: fontDescriptor, size: fontSize)

        return italicSystemFont ?? systemFont // Return italic font or fallback to system font
    }
}

#endif

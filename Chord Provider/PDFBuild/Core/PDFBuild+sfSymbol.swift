//
//  PDFBuild+sfSymbol.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    /// Add an SF Symbol as `NSTextAttachment`
    /// - Parameters:
    ///   - sfSymbol: The ``SFSymbol`` to use
    ///   - fontSize: The size of the font
    ///   - nsColor: The color of the icon
    /// - Returns: An `NSTextAttachment`
    static func sfSymbol(sfSymbol: SFSymbol, fontSize: Double, nsColor: NSColor) -> NSTextAttachment {
        return PDFBuild.sfSymbol(sfSymbol: sfSymbol.rawValue, fontSize: fontSize, nsColors: [nsColor])
    }

    /// Add an SF Symbol as `NSTextAttachment`
    /// - Parameters:
    ///   - sfSymbol: The ``SFSymbol`` to use
    ///   - fontSize: The size of the font
    ///   - nsColors: The colors of the icon
    /// - Returns: An `NSTextAttachment`
    static func sfSymbol(sfSymbol: String, fontSize: Double, nsColors: [NSColor]) -> NSTextAttachment {
        /// Get a large SF symbol and scale it back to expected size or else it will be super blurry
        var config = NSImage.SymbolConfiguration(pointSize: fontSize * 3, weight: .medium, scale: .medium)
        config = config.applying(.init(paletteColors: nsColors))
        guard
            let sfImage = NSImage(systemSymbolName: sfSymbol, accessibilityDescription: nil)?.withSymbolConfiguration(config),
            let cgImage = sfImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return NSTextAttachment()
        }
        let imageSize = NSSize(width: sfImage.size.width / 3, height: sfImage.size.height / 3)
        let image = NSImage(cgImage: cgImage, size: imageSize)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        /// Align the image
        imageAttachment.bounds = CGRect(
            x: CGFloat(0),
            y: (NSFont.systemFont(ofSize: fontSize, weight: .regular).capHeight - imageSize.height) / 2,
            width: imageSize.width,
            height: imageSize.height
        )
        return imageAttachment
    }
}

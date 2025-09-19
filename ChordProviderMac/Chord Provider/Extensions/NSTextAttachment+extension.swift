//
//  NSTextAttachment+extension.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension NSTextAttachment {

    /// Add  an SF Image as attachment
    /// - Parameters:
    ///   - sfSymbol: The name of the SF icon
    ///   - fontSize: The font size for the SF icon
    ///   - colors: The colors for the SF icon
    /// - Returns: An `NSTextAttachment` with the SF icon
    func sfSymbol(sfSymbol: String, fontSize: Double, colors: [NSColor]) -> NSTextAttachment {
        let image = PDFBuild.Image(sfSymbol, fontSize: fontSize, colors: colors)
        self.image = image.image
        /// Align the image
        if let imageSize = image.fixedSize {
            self.bounds = CGRect(
                x: CGFloat(0),
                y: (NSFont.systemFont(ofSize: fontSize, weight: .regular).capHeight - imageSize.height) / 2,
                width: imageSize.width,
                height: imageSize.height
            )
        }
        return self
    }
}

//
//  PDFBuild+Image.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit
import AVFoundation

extension PDFBuild {

    // MARK: A PDF **image** element

    /// A PDF **image** element
    class Image: PDFElement {
        /// The image to draw
        let image: NSImage
        /// The optional fixed size of the image
        let fixedSize: CGSize?
        /// The alignment
        let alignment: NSTextAlignment
        /// The optional offset
        let offset: CGSize
        /// Bool if the image should be resized if it does not fit
        let resizeImage: Bool

        /// Init the **image** element
        /// - Parameters:
        ///   - image: The `NSImage` to draw
        ///   - size: The optional size of the image
        ///   - alignment: The alignment of the image
        ///   - offset: The offset of the image
        init(_ image: NSImage, size: CGSize? = nil, alignment: NSTextAlignment = .center, offset: CGSize = .zero) {
            self.image = image
            self.fixedSize = size
            self.alignment = alignment
            self.offset = offset
            self.resizeImage = true
        }

        /// Init the **image** element with an SF symbol
        /// - Parameters:
        ///   - sfSymbol: The `SF Symbol`as `String` to draw
        ///   - fontSize: The font size for the symbol
        ///   - colors: The colors for the symbol
        init(_ sfSymbol: String, fontSize: Double, colors: [NSColor]) {
            self.alignment = .left
            self.offset = .zero
            /// Never resize SF symbols
            self.resizeImage = false
            var config = NSImage.SymbolConfiguration(pointSize: fontSize * 3, weight: .medium, scale: .medium)
            config = config.applying(.init(paletteColors: colors))
            if
                let sfImage = NSImage(systemSymbolName: sfSymbol, accessibilityDescription: nil)?.withSymbolConfiguration(config),
                let cgImage = sfImage.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                /// Add the image
                self.fixedSize = NSSize(width: sfImage.size.width / 3, height: sfImage.size.height / 3)
                self.image = NSImage(cgImage: cgImage, size: fixedSize ?? .zero)
            } else {
                self.image = NSImage(size: .zero)
                self.fixedSize = nil
            }
        }

        /// Init the **image** element with an SF symbol
        /// - Parameters:
        ///   - sfSymbol: The `SF Symbol`as ``SFSymbol`` to draw
        ///   - fontSize: The font size for the symbol
        ///   - colors: The colors for the symbol
        convenience init(_ sfSymbol: SFSymbol, fontSize: Double, colors: [NSColor]) {
            self.init(sfSymbol.rawValue, fontSize: fontSize, colors: colors)
        }

        /// Draw the **image**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Set the size of the image
            var size = fixedSize ?? .zero
            if fixedSize == nil {
                size = CGSize(
                    width: rect.width,
                    height: rect.width / image.size.width * image.size.height
                )
            }
            /// Make sure images always fit
            if resizeImage, size.width > rect.width {
                size.width = rect.width
                size.height = rect.width / image.size.width * image.size.height
            }
            /// Apply optional y-offset
            rect.origin.y += offset.height
            rect.size.height -= offset.height
            /// Build a rect
            var tempRect = CGRect(
                x: rect.minX,
                y: rect.minY,
                width: size.width,
                height: size.height
            )
            /// Apply alignment and optional x-offset
            switch alignment {
            case .left:
                tempRect.origin.x = rect.minX + offset.width
            case .right:
                tempRect.origin.x = rect.maxX - size.width + offset.width
            default:
                /// Center align
                tempRect.origin.x = offset.width + rect.minX + ((rect.maxX - rect.minX) - size.width) / 2
            }
            let imgRect = AVMakeRect(
                aspectRatio: image.size,
                insideRect: tempRect
            )
            if !calculationOnly {
                image.draw(in: imgRect)
            }
            rect.origin.y += tempRect.height
            if tempRect.height > rect.size.height {
                rect.size.height = 0
            } else {
                rect.size.height -= tempRect.height
            }
        }
    }
}

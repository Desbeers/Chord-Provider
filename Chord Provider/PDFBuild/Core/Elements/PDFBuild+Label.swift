//
//  PDFBuild+Label.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **label** element

    /// A PDF **label** element
    class Label: PDFElement {

        /// The text of the label
        let labelText: NSAttributedString
        /// Optional SF Symbol icon
        let sfSymbol: String?
        /// Bool to draw a background or not
        let drawBackground: Bool
        /// The alignment of the label
        let alignment: NSTextAlignment
        /// The corner radius of the label
        let cornerRadius: CGFloat = 3
        /// The font options
        let fontOptions: ConfigOptions.FontOptions

        /// Init the **label** element
        /// - Parameters:
        ///   - labelText: The text of the label
        ///   - sfSymbol: Optional SF Symbol icon
        ///   - drawBackground: Bool to draw a background or not
        ///   - alignment: The alignment of the label
        ///   - fontOptions: The font options
        init(
            labelText: NSAttributedString,
            sfSymbol: String? = nil,
            drawBackground: Bool,
            alignment: NSTextAlignment,
            fontOptions: ConfigOptions.FontOptions
        ) {
            self.labelText = labelText
            self.sfSymbol = sfSymbol
            self.drawBackground = drawBackground
            self.alignment = alignment
            self.fontOptions = fontOptions
        }
        /// Draw the **label** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var cgImage: CGImage?
            var imageOffset: Double = 0
            var textRect = rect.insetBy(dx: 2 * textPadding, dy: 2 * textPadding)
            var imageRect = textRect
            /// Prepair the optional `SF symbol`
            if let sfSymbol {
                var config = NSImage.SymbolConfiguration(pointSize: fontOptions.size * 10, weight: .medium, scale: .medium)
                config = config.applying(.init(paletteColors: [NSColor(fontOptions.color)]))
                if let sfImage = NSImage(systemSymbolName: sfSymbol, accessibilityDescription: nil)?.withSymbolConfiguration(config) {
                    cgImage = sfImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
                    imageRect.size.width = sfImage.size.width / 10
                    imageRect.size.height = sfImage.size.height / 10
                    imageOffset = imageRect.size.width + (2 * textPadding)
                    /// Move the text rect
                    textRect.origin.x += imageOffset
                    textRect.size.width -= imageOffset
                }
            }
            let labelBounds = labelText.boundingRect(with: textRect.size, options: .usesLineFragmentOrigin)
            let width = labelBounds.width + (4 * textPadding)
            let height = labelBounds.height + (4 * textPadding)
            var fillRect = CGRect(
                x: rect.origin.x,
                y: rect.origin.y,
                width: width + imageOffset,
                height: height
            )
            /// Calculate `X` based on alignment
            var xOffset: CGFloat = 0
            switch alignment {
            case .left:
                xOffset -= 4 * textPadding
            case .center:
                let offset = (rect.width - width) / 2
                xOffset += offset
            case .right:
                let offset = rect.width - width
                xOffset += offset
            case .justified:
                break
            case .natural:
                break
            @unknown default:
                break
            }
            /// Move all the rects
            fillRect.origin.x += xOffset
            imageRect.origin.x += xOffset
            textRect.origin.x += xOffset
            /// Draw the label
            if !calculationOnly, let context = NSGraphicsContext.current?.cgContext {
                /// Add clip
                NSBezierPath(roundedRect: fillRect, xRadius: cornerRadius, yRadius: cornerRadius).addClip()
                /// Draw the optional background
                if drawBackground {
                    context.setFillColor(NSColor(fontOptions.background).cgColor)
                    context.fill(fillRect)
                }
                /// Draw the optional SF symbol
                if let cgImage {
                    context.drawFlipped(cgImage, in: imageRect)
                }
                /// Draw the label text
                labelText.draw(with: textRect, options: textDrawingOptions, context: nil)
                /// Reset the clip
                context.resetClip()
            }
            /// Set the new rect size
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}


extension CGContext {

    /// Draw `image` flipped vertically, positioned and scaled inside `rect`.
    public func drawFlipped(_ image: CGImage, in rect: CGRect) {
        self.saveGState()
        self.translateBy(x: 0, y: rect.origin.y + rect.height)
        self.scaleBy(x: 1.0, y: -1.0)
        self.draw(image, in: CGRect(origin: CGPoint(x: rect.origin.x, y: 0), size: rect.size))
        self.restoreGState()
    }
}

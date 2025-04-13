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
        /// Optional icon
        let sfIcon: String?
        /// The `NSColor` background of the label
        let backgroundColor: NSColor
        /// The alignment of the label
        let alignment: NSTextAlignment
        /// The corner radius of the label
        let cornerRadius: CGFloat = 3
        /// The font options
        let fontOptions: ConfigOptions.FontOptions

        /// Init the **label** element
        /// - Parameters:
        ///   - labelText: The text of the label
        ///   - sfIcon: Optional icon
        ///   - backgroundColor: The `NSColor` background of the label
        ///   - alignment: The alignment of the label
        ///   - fontOptions: The font options
        init(
            labelText: NSAttributedString,
            sfIcon: String? = nil,
            backgroundColor: NSColor,
            alignment: NSTextAlignment,
            fontOptions: ConfigOptions.FontOptions
        ) {
            self.labelText = labelText
            self.sfIcon = sfIcon
            self.backgroundColor = backgroundColor
            self.alignment = alignment
            self.fontOptions = fontOptions
        }

        /// Draw the **label** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {


            let textRect = rect.insetBy(dx: 2 * textPadding, dy: 2 * textPadding)
            var labelRect = textRect

            var cgImage: CGImage?

            var imageRect = CGRect()

            var imageOffset: Double = 0

            if let sfIcon {
                var config = NSImage.SymbolConfiguration(pointSize: fontOptions.size * 10, weight: .medium, scale: .medium)
                config = config.applying(.init(paletteColors: [NSColor(fontOptions.color)]))
                if let sfImage = NSImage(systemSymbolName: sfIcon, accessibilityDescription: nil)?.withSymbolConfiguration(config) {
                    cgImage = sfImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
                    imageRect = rect
                    imageRect.size.width = sfImage.size.width / 12
                    imageRect.size.height = sfImage.size.height / 12
                    imageRect.origin.y += (rect.height - imageRect.size.height) / 1.8
                    imageOffset = imageRect.size.width + (2 * textPadding)
                }
            }

            let labelBounds = labelText.boundingRect(with: labelRect.size, options: .usesLineFragmentOrigin)
            var width = labelBounds.width + (4 * textPadding)

            let height = labelBounds.height + (4 * textPadding)
            /// Calculate `X` based on alignment
            var xOffset: CGFloat = 0

            if cgImage != nil {
                width += imageOffset + textPadding
                xOffset += imageOffset
            }

            switch alignment {
            case .left:
                xOffset -= 2 * textPadding
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
            labelRect.origin.x += xOffset
            let fillRect = CGRect(
                x: rect.origin.x + xOffset - imageOffset,
                y: rect.origin.y,
                width: width,
                height: height
            )
            if !calculationOnly, let context = NSGraphicsContext.current?.cgContext {

                /// Add clip
                NSBezierPath(roundedRect: fillRect, xRadius: cornerRadius, yRadius: cornerRadius).addClip()
                /// Draw the background
                context.setFillColor(backgroundColor.cgColor)
                context.fill(fillRect)

                /// Draw icon
                if let cgImage {
                    context.drawFlipped(cgImage, in: imageRect)
                }

                /// Draw the label text
                labelText.draw(with: labelRect, options: textDrawingOptions, context: nil)
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

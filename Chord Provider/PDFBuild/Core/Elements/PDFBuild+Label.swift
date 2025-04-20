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
        let sfSymbol: SFSymbol?
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
            sfSymbol: SFSymbol? = nil,
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
            let text = NSMutableAttributedString()
            if let sfSymbol {
                let imageAttachment = PDFBuild.sfSymbol(
                    sfSymbol: sfSymbol,
                    fontSize: fontOptions.size,
                    nsColor: NSColor(fontOptions.color)
                )
                text.append(NSAttributedString(attachment: imageAttachment))
                let attributes = labelText.fontAttributes(in: .init(location: 0, length: labelText.length))
                text.append(NSAttributedString(string: " ", attributes: attributes))
            }
            text.append(labelText)
            var textRect = rect.insetBy(dx: 2 * textPadding, dy: 2 * textPadding)
            let labelBounds = labelText.boundingRect(with: textRect.size, options: .usesLineFragmentOrigin)
            let textBounds = text.boundingRect(with: textRect.size, options: .usesLineFragmentOrigin)

            let width = textBounds.width + (4 * textPadding)
            let height = labelBounds.height + (4 * textPadding)

            /// Move the textRect
            /// - Note: An SF symbol does not like to be less than 14...
            let yOffset = (textBounds.height - labelBounds.height) / 1.3
            textRect.origin.y -= yOffset
            textRect.size.height = textBounds.height

            var fillRect = CGRect(
                x: rect.origin.x,
                y: rect.origin.y,
                width: width,
                height: height
            )
            /// Calculate `X` based on alignment
            var xOffset: CGFloat = 0
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
            /// Move all the rects
            fillRect.origin.x += xOffset
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
                /// Draw the text
                text.draw(with: textRect, options: textDrawingOptions, context: nil)
                /// Reset the clip
                context.resetClip()
            }
            /// Set the new rect size
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

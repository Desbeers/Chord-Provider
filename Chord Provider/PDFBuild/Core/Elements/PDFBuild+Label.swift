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
        /// The `NSColor` background of the label
        let backgroundColor: NSColor
        /// The alignment of the label
        let alignment: NSTextAlignment
        /// The corner radius of the label
        let cornerRadius: CGFloat = 3

        /// Init the **label** element
        /// - Parameters:
        ///   - labelText: The text of the label
        ///   - backgroundColor: The `NSColor` background of the label
        ///   - alignment: The alignment of the label
        init(
            labelText: NSAttributedString,
            backgroundColor: NSColor,
            alignment: NSTextAlignment
        ) {
            self.labelText = labelText
            self.backgroundColor = backgroundColor
            self.alignment = alignment
        }

        /// Draw the **label** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let textRect = rect.insetBy(dx: 2 * textPadding, dy: 2 * textPadding)
            var labelRect = textRect
            let labelBounds = labelText.boundingRect(with: labelRect.size, options: .usesLineFragmentOrigin)
            let width = labelBounds.width + (4 * textPadding)
            let height = labelBounds.height + (4 * textPadding)
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
            labelRect.origin.x += xOffset
            let fillRect = CGRect(
                x: rect.origin.x + xOffset,
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

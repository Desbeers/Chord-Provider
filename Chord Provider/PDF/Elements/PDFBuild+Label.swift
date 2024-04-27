//
//  PDFBuild+Label.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild {

    /// A PDF label item
    public class Label: PDFElement {

        let leading: NSAttributedString?
        let label: NSAttributedString
        let color: SWIFTColor
        let alignment: NSTextAlignment

        let cornerRaduis: CGFloat = 3

        init(leading: NSAttributedString? = nil, label: NSAttributedString, color: SWIFTColor, alignment: NSTextAlignment) {
            self.leading = leading
            self.label = label
            self.color = color
            self.alignment = alignment
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            let textRect = rect.insetBy(dx: 2 * PDFElement.textPadding, dy: 2 * PDFElement.textPadding)

            var labelRect = textRect

            var leadingBounds: CGRect = .zero
            var leadingRect: CGRect = .zero

            if let leading {
                /// Check how much space is needed for the leading; later used to calculate the background size
                leadingBounds = leading.bounds(withSize: textRect.size)
                /// Store the size to render the leading after the clipping and background
                leadingRect = textRect
                /// Adjust the remaining rect for the label
                labelRect.origin.x += (leadingBounds.size.width + 2 * PDFElement.textPadding)
                labelRect.size.width -= (leadingBounds.size.width + (6 * PDFElement.textPadding))
            }

            let labelBounds = label.bounds(withSize: labelRect.size)
            let width = leadingBounds.width + labelBounds.width + ((leading == nil ? 2 : 3) * 2 * PDFElement.textPadding)
            let height = labelBounds.height + (4 * PDFElement.textPadding)

            /// Calculate `X` based on alignment

            var xOffset: CGFloat = 0

            switch alignment {
            case .left:
                break
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

            leadingRect.origin.x += xOffset
            labelRect.origin.x += xOffset

            let fillRect = CGRect(
                x: rect.origin.x + xOffset,
                y: rect.origin.y,
                width: width,
                height: height
            )
            if !calculationOnly, let context = UIGraphicsGetCurrentContext() {
                /// Add clip
                SWIFTBezierPath(roundedRect: fillRect, cornerRadius: cornerRaduis).addClip()
                /// Draw the background
                context.setFillColor(color.cgColor)
                context.fill(fillRect)
                /// Draw the leading if set
                if let leading {
                    leading.draw(with: leadingRect, options: textDrawingOptions, context: nil)
                }
                /// Draw the label
                label.draw(with: labelRect, options: textDrawingOptions, context: nil)
                /// Reset the clip
                context.resetClip()
            }

            /// Set the new rect size
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

// MARK: Label string styling

public extension StringAttributes {

    static var sectionLabel: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular)
        ]
    }
}

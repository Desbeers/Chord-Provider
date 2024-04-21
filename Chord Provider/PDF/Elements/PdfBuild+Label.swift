//
//  PdfBuild+Label.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    /// A PDF label item
    public class Label: PdfElement {

        let leading: NSAttributedString?
        let label: NSAttributedString
        let color: SWIFTColor
        let alignment: NSTextAlignment

        let padding: CGFloat = 4
        let cornerRaduis: CGFloat = 3

        let options: NSString.DrawingOptions = [
            /// Render the string in multiple lines
            .usesLineFragmentOrigin,
            .truncatesLastVisibleLine
        ]

        init(leading: NSAttributedString? = nil, label: NSAttributedString, color: SWIFTColor, alignment: NSTextAlignment) {
            self.leading = leading
            self.label = label
            self.color = color
            self.alignment = alignment
        }

        open override func draw(rect: inout CGRect) {

            if let context = UIGraphicsGetCurrentContext() {


                let textRect = rect.insetBy(dx: padding, dy: padding)

                var labelRect = textRect

                var leadingBounds: CGRect = .zero
                var leadingRect: CGRect = .zero

                if let leading {
                    /// Check how much space is needed for the leading; later used to calculate the background size
                    leadingBounds = leading.bounds(withSize: textRect.size)
                    /// Store the size to render the leading after the clipping and background
                    leadingRect = textRect
                    /// Adjust the remaining rect for the label
                    labelRect.origin.x += (leadingBounds.size.width + padding)
                    labelRect.size.width -= (leadingBounds.size.width + (3 * padding))
                }

                let labelBounds = label.bounds(withSize: labelRect.size)
                let width = leadingBounds.width + labelBounds.width + ((leading == nil ? 2 : 3) * padding)
                let height = labelBounds.height + (2 * padding)



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

                /// Add clip
                SWIFTBezierPath(roundedRect: fillRect, cornerRadius: cornerRaduis).addClip()
                context.clip()

                /// Draw the background
                context.setFillColor(color.cgColor)
                context.fill(fillRect)

                /// Draw the leading if set
                if let leading {
                    leading.draw(with: leadingRect, options: options, context: nil)
                }
                /// Draw the label
                label.draw(with: labelRect, options: options, context: nil)

                /// Reset the clip
                context.resetClip()

                /// Set the new rect size
                rect.origin.y += height
                rect.size.height -= height
            }
        }
    }
}

// MARK: Label string styling

public extension StringAttributes {

    static var sectionLabel: StringAttributes {
        [
            .foregroundColor: SWIFTColor.black,
            .font: SWIFTFont.systemFont(ofSize: 10, weight: .regular),
        ]
    }
}

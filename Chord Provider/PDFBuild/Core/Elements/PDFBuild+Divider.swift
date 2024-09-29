//
//  PDFBuild+Divider.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **divider** element

    /// A PDF **divider** element
    class Divider: PDFElement {
        /// The ``direction`` of the divider
        let direction: Direction
        /// The line with of the divider
        let lineWidth: CGFloat = 0.6
        /// The color of the divider
        let strokeColor = NSColor.lightGray.cgColor

        /// Init the **divider** element
        /// - Parameter direction: The direction of the `divider`
        init(direction: Direction = .vertical) {
            self.direction = direction
        }

        /// Draw the **divider**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            if let context = NSGraphicsContext.current?.cgContext {
                switch direction {
                case .horizontal:
                    if !calculationOnly {
                        let start = CGPoint(
                            x: rect.origin.x,
                            y: rect.origin.y + 2.5
                        )
                        context.move(to: start)
                        context.addLine(to: CGPoint(x: start.x + rect.size.width, y: start.y))
                    }
                    rect.origin.y += 5
                    rect.size.height -= 5
                case .vertical:
                    if !calculationOnly {
                        let start = CGPoint(
                            x: rect.origin.x + (rect.width / 2) - 0.3,
                            y: rect.origin.y
                        )
                        context.move(to: start)
                        context.addLine(to: CGPoint(x: start.x, y: start.y + rect.size.height))
                    }
                    rect.origin.x += 1
                    rect.size.width -= 1
                }
                context.setStrokeColor(strokeColor)
                context.setLineWidth(lineWidth)
                context.strokePath()
            }
        }
    }

    /// Directions that can be used to align a `PDFElement`
    enum Direction {
        /// Horizontal direction
        case horizontal
        /// Vertical direction
        case vertical
    }
}

//
//  PDFBuild+Background.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **background** element

    /// A PDF **background** element
    ///
    /// Fill a ``PDFElement`` with a `NSColor` background
    class Background: PDFElement {

        /// The `NSColor` for the background
        let color: NSColor
        /// The ``PDFElement`` to add on top of the background
        let element: PDFElement

        /// Init the **background** element
        /// - Parameters:
        ///   - color: The `NSColor` for the background
        ///   - element: The ``PDFElement`` to add on top of the background
        init(color: NSColor, _ element: PDFElement) {
            self.color = color
            self.element = element
        }

        /// Draw the **background** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Render the background below the element
            if !calculationOnly, let context = NSGraphicsContext.current?.cgContext {
                let tempRect = calculateDraw(rect: rect, elements: [element], pageRect: pageRect)
                var fillRect = rect
                fillRect.size.height = rect.height - tempRect.height
                context.setFillColor(color.cgColor)
                context.fill(fillRect)
            }
            /// Draw whatever goes on top of the background
            element.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}

//
//  PDFBuild+Background.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild {

    /// A PDF **background** element
    ///
    /// Fill a ``PDFElement`` with a ``SWIFTColor`` background
    class Background: PDFElement {

        /// The ``SWIFTColor`` for the background
        let color: SWIFTColor
        /// The ``PDFElement`` to add on top of the background
        let element: PDFElement

        /// Init the **background** element
        /// - Parameters:
        ///   - color: The ``SWIFTColor`` for the background
        ///   - element: The ``PDFElement`` to add on top of the background
        init(color: SWIFTColor, _ element: PDFElement) {
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
            if !calculationOnly, let context = UIGraphicsGetCurrentContext() {
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

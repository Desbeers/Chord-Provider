//
//  PDFBuild+Background.swift
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

    /// A PDF background item
    open class Background: PDFElement {

        /// The color for the background
        let color: SWIFTColor
        /// The ``PDFElement`` to add on top of the background
        let element: PDFElement

        /// Fill a ``PDFElement`` with a background color
        /// - Parameters:
        ///   - color: The color for the background
        ///   - element: The ``PDFElement``
        public init(color: SWIFTColor, _ element: PDFElement) {
            self.color = color
            self.element = element
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            /// Render the background below the element
            if !calculationOnly {
                let tempRect = calculateDraw(rect: rect, elements: [element])
                var fillRect = rect
                fillRect.size.height = rect.height - tempRect.height
                let context = UIGraphicsGetCurrentContext()
                context?.setFillColor(color.cgColor)
                context?.fill(fillRect)
            }
            /// Render whatever goes on top of the background
            element.draw(rect: &rect, calculationOnly: calculationOnly)
        }
    }
}

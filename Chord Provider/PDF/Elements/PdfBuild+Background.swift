//
//  PdfBuild+Background.swift
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

    /// A PDF background item
    open class Background: PdfElement {

        /// The color for the background
        let color: SWIFTColor
        /// The ``PdfElement`` to add on top of te background
        let element: PdfElement

        /// Fill a ``PdfElement`` with a background color
        /// - Parameters:
        ///   - color: The color for the background
        ///   - element: The ``PdfElement``
        public init(color: SWIFTColor, _ element: PdfElement) {
            self.color = color
            self.element = element
        }

        open override func draw(rect: inout CGRect) {
            let tempRect = estimateDraw(rect: rect, elements: [element])

            var fillRect = rect
            fillRect.size.height = rect.height - tempRect.height

            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.fill(fillRect)

            element.draw(rect: &rect)
        }
    }
}

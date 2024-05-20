//
//  PDFBuild+Padding.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **padding** element
    class Padding: PDFElement {

        /// The size of the padding
        let size: CGFloat
        /// The ``PDFElement`` that will be padded
        let element: PDFElement

        /// Init the **padding** element
        /// - Parameters:
        ///   - size: The size of the padding
        ///   - element: The ``PDFElement`` that will be padded
        init(size: CGFloat, _ element: PDFElement) {
            self.size = size
            self.element = element
        }

        /// Draw the **padding**
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the size should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            var insetRect = rect.insetBy(dx: size, dy: size)
            element.draw(rect: &insetRect, calculationOnly: calculationOnly, pageRect: pageRect)
            let height = rect.height - insetRect.height
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

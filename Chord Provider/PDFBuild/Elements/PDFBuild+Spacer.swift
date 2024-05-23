//
//  PDFBuild+Spacer.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **spacer** element
    class Spacer: PDFElement {

        /// The amount of space to use
        var space: CGFloat

        /// Init the **spacer** element
        /// - Parameter space: The amount of space to use
        init(_ space: CGFloat = 5) {
            self.space = space
        }

        /// Draw the **spacer** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            rect.origin.y += space
            rect.size.height -= space
        }
    }
}

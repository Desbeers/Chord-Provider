//
//  PDFBuild+PageBackgroundColor.swift
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

    /// A PDF **page background color** element
    class PageBackgroundColor: PDFElement {

        /// The ``SWIFTColor`` for the background
        let color: SWIFTColor

        /// Fill a page with a background color
        /// - Parameters:
        ///   - color: The ``SWIFTColor`` for the background
        init(color: SWIFTColor) {
            self.color = color
        }

        /// Draw the **page background color** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        /// - Note: the rect value will be ignored and the full page size will be used
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Render the background below the element
            if !calculationOnly, let context = UIGraphicsGetCurrentContext() {
                context.setFillColor(color.cgColor)
                context.fill(pageRect)
            }
        }
    }
}

//
//  PDFBuild+PageBackgroundColor.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: A PDF **page background color** element

    /// A PDF **page background color** element
    class PageBackgroundColor: PDFElement {

        /// The `NSColor` for the background
        let color: NSColor

        /// Fill a page with a background color
        /// - Parameters:
        ///   - color: The `NSColor` for the background
        init(color: NSColor) {
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
            if !calculationOnly, let context = NSGraphicsContext.current?.cgContext {
                context.setFillColor(color.cgColor)
                context.fill(pageRect)
            }
        }
    }
}

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

    /// A PDF page background color item
    open class PageBackgroundColor: PDFElement {

        /// The color for the background
        let color: SWIFTColor

        /// Fill a page with a background color
        /// - Parameters:
        ///   - color: The color for the background
        public init(color: SWIFTColor) {
            self.color = color
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            /// Render the background below the element
            if !calculationOnly, let context = UIGraphicsGetCurrentContext() {
                let fillRect = PDFBuild.a4portraitPage
                context.setFillColor(color.cgColor)
                context.fill(fillRect)
            }
        }
    }
}

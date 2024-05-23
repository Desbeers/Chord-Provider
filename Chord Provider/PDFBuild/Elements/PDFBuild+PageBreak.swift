//
//  PDFBuild+PageBreak.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **page break** element
    ///
    /// This element will close the current page and start a new one
    class PageBreak: PDFElement {

        /// Check if an ``PDFElement`` fits on the current page or if it should break
        /// - Parameter rect: The available rectangle
        /// - Returns: Bool if the page should break (always true for this element)
        func shoudPageBreak(rect: CGRect, pageRect: CGRect) -> Bool {
            true
        }
    }
}

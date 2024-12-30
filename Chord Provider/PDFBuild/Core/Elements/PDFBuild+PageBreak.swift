//
//  PDFBuild+PageBreak.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **page break** element

    /// A PDF **page break** element
    ///
    /// This element will close the current page and start a new one
    class PageBreak: PDFElement {

        /// Check if an ``PDFElement`` fits on the current page or if it should break
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - pageRect: The rect of the page
        /// - Returns: Bool if the page should break (always true for this element)
        func shouldPageBreak(rect: CGRect, pageRect: CGRect) -> Bool {
            true
        }
    }
}

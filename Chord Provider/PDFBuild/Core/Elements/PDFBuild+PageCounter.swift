//
//  PDFBuild+PageCounter.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **page counter** element

    /// A PDF **page counter** element
    /// 
    /// - Keep a list of items for the TOC
    /// - Drawing of the **page counter**
    class PageCounter: PDFElement {

        /// The number of the first page
        let firstPage: Int
        /// The current page number
        var pageNumber: Int
        /// The attributes for the page counter string
        let attributes: PDFStringAttribute
        /// The TOC items in the document
        /// - Note: The `ContentItem` element can add elements to this array
        var tocItems: [TOCInfo] = []

        /// Init the **page counter** element
        /// - Parameters:
        ///   - firstPage: The number of the first page
        ///   - attributes: The attributes for the page counter string
        init(firstPage: Int, attributes: PDFStringAttribute = PDFStringAttribute()) {
            self.firstPage = firstPage
            self.pageNumber = firstPage
            self.attributes = attributes
        }

        /// Draw the **page counter** element with a `Text` element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            let pageCounter = PDFBuild.Text(String(pageNumber), attributes: attributes)
            pageCounter.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }
    }
}

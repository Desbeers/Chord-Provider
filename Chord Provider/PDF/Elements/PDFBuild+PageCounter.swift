//
//  PDFBuild+PageCounter.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **page counter** element
    /// 
    /// - Keep a list of items for the TOC
    /// - Drawing of the **page counter**
    class PageCounter: PDFElement {

        /// The number of the first page
        public let firstPage: Int
        /// The current page number
        public var pageNumber: Int
        /// The attributes for the page counter string
        public let attributes: StringAttributes
        /// The TOC items in the document
        /// - Note: The `ContentItem` element can add elements to this array
        public var tocItems: [TOCInfo] = []

        /// Init the **page counter** element
        /// - Parameters:
        ///   - firstPage: The number of the first page
        ///   - attributes: The attributes for the page counter string
        init(firstPage: Int, attributes: StringAttributes = StringAttributes()) {
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

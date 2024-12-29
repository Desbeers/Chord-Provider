//
//  PDFBuild+ContentItem.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **content item** element

    /// A PDF **content item** element
    ///
    /// This element is not drawing anything but stores item information in the `PageCounter` class for creating a TOC
    /// - Store the first page number of the item
    class ContentItem: PDFElement {

        /// Information about the item
        let tocInfo: TOCInfo
        /// The `PageCounter` class
        let counter: PDFBuild.PageCounter

        /// Init the **content item** element
        /// - Parameters:
        ///   - item: Information about the item
        ///   - counter: The `PageCounter` class
        init(tocInfo: TOCInfo, counter: PDFBuild.PageCounter) {
            self.tocInfo = tocInfo
            self.counter = counter
        }

        /// Draw the **item section** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        /// - Note: This is not drawing anything but storing item information
        ///         in the `PageCounter` class for creating a TOC
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            if !calculationOnly, let index = counter.tocItems.firstIndex(where: { $0.id == tocInfo.id }) {
                /// Update the item in the `PageCounter` class
                counter.tocItems[index].pageNumber = counter.pageNumber
            }
        }
    }
}

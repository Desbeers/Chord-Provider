//
//  PDFBuild+ContentItem.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **content item** element
    ///
    /// This element is not drawing anything but stores item information in the `PageCounter` class for creating a TOC
    /// - Store the metadata of the item
    /// - Store the first page number of the item
    class ContentItem: PDFElement {

        /// Information about the item
        var tocInfo: TOCInfo
        /// The `PageCounter` class
        var counter: PDFBuild.PageCounter

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
        /// - Note: This is not drawing anything but storing item information in the `PageCounter` class for creating a TOC
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            if !calculationOnly {
                /// Update the page number
                tocInfo.pageNumber = counter.pageNumber
                /// Add it to the `PageCounter` class
                counter.tocItems.append(tocInfo)
            }
        }
    }
}

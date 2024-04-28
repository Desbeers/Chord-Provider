//
//  PDFBuild+TOCItem.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **TOC item** element
    class TOCItem: PDFElement {

        /// Information about the item
        var tocInfo: PDFBuild.TOCInfo
        /// The `PageCounter` class
        var counter: PDFBuild.PageCounter

        /// Init the **TOC item** element
        /// - Parameters:
        ///   - tocInfo: Information about the item
        ///   - counter: The `PageCounter` class
        init(tocInfo: PDFBuild.TOCInfo, counter: PDFBuild.PageCounter) {
            self.tocInfo = tocInfo
            self.counter = counter
        }

        /// Draw the **TOC item** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func draw(rect: inout CGRect, calculationOnly: Bool) {
            /// Remember the start rectangle to calculate the used space at the end
            let startRect = rect
            /// Define the TOC item with `PDFBuild` elements
            let tocItem = PDFBuild.Section(
                columns: [.fixed(width: 30), .flexible, .flexible],
                items: [
                    PDFBuild.Text("\(tocInfo.pageNumber)", attributes: .alignment(.right)),
                    PDFBuild.Text("\(tocInfo.title)"),
                    PDFBuild.Text("\(tocInfo.subtitle)")
                ]
            )
            /// Draw the TOC item
            tocItem.draw(rect: &rect, calculationOnly: calculationOnly)
            /// Calculate the used space and update the item in the `PageCounter` class
            if !calculationOnly, let index = counter.tocItems.firstIndex(where: { $0.pageNumber == tocInfo.pageNumber }) {
                let usedRect = CGRect(
                    x: startRect.origin.x,
                    y: startRect.origin.y,
                    width: startRect.width,
                    height: startRect.height - rect.height
                )
                tocInfo.rect = usedRect
                counter.tocItems[index] = tocInfo
            }
        }
    }
}

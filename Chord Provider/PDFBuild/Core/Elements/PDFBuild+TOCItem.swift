//
//  PDFBuild+TOCItem.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    // MARK: A PDF **TOC item** element

    /// A PDF **TOC item** element
    class TOCItem: PDFElement {

        /// Information about the item
        var tocInfo: PDFBuild.TOCInfo
        /// The `PageCounter` class
        var counter: PDFBuild.PageCounter
        /// The PDF settings
        let settings: AppSettings.PDF

        /// Init the **TOC item** element
        /// - Parameters:
        ///   - tocInfo: Information about the item
        ///   - counter: The `PageCounter` class
        ///   - settings: The PDF settings
        init(tocInfo: PDFBuild.TOCInfo, counter: PDFBuild.PageCounter, settings: AppSettings.PDF) {
            self.tocInfo = tocInfo
            self.counter = counter
            self.settings = settings
        }

        /// Draw the **TOC item** element
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Remember the start rectangle to calculate the used space at the end
            let startRect = rect
            /// Define the TOC item with `PDFBuild` elements
            let tocItem = PDFBuild.Section(
                columns: [.flexible, .flexible, .fixed(width: 30)],
                items: [
                    PDFBuild.Text("\(tocInfo.song.metadata.title)", attributes: .foregroundColor(settings: settings)),
                    PDFBuild.Text("\(tocInfo.song.metadata.artist)", attributes: .foregroundColor(settings: settings)),
                    PDFBuild.Text("\(tocInfo.pageNumber)", attributes: .alignment(.right) + .foregroundColor(settings: settings))
                ]
            )
            /// Draw the TOC item
            tocItem.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            /// Calculate the used space and update the item in the `PageCounter` class
            if !calculationOnly, let index = counter.tocItems.firstIndex(where: { $0.id == tocInfo.id }) {
                let usedRect = CGRect(
                    x: startRect.origin.x,
                    y: startRect.origin.y,
                    width: startRect.width,
                    height: startRect.height - rect.height
                )
                tocInfo.rect = usedRect
                tocInfo.tocPageNumber = tocInfo.tocPageNumber == 0 ? counter.pageNumber : tocInfo.tocPageNumber
                counter.tocItems[index] = tocInfo
            }
        }
    }
}

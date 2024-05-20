//
//  PDFBuild+PageHeader.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF **page header and footer** element
    class PageHeaderFooter: PDFElement {

        /// The header of the page
        let header: [PDFElement]
        /// The footer of the page
        let footer: [PDFElement]

        /// Init the **page header and footer** element
        /// - Parameters:
        ///   - header: The `PDFElements` for the header
        ///   - footer: The `PDFElements` for the header
        init(header: [PDFElement], footer: [PDFElement] = []) {
            self.header = header
            self.footer = footer
        }

        /// Draw the **page header and footer** elements
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        ///   - pageRect: The page size of the PDF document
        func draw(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            drawHeader(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            drawFooter(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
        }

        /// Draw the **header** elements
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func drawHeader(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            for item in header {
                item.draw(rect: &rect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
        }

        /// Draw the **footer** elements
        /// - Parameters:
        ///   - rect: The available rectangle
        ///   - calculationOnly: Bool if only the Bounding Rect should be calculated
        func drawFooter(rect: inout CGRect, calculationOnly: Bool, pageRect: CGRect) {
            /// Calculate the footer rectangle
            let tempRect = calculateDraw(rect: rect, elements: footer, pageRect: pageRect)
            let move = tempRect.height
            let contentHeight = rect.height - move
            var bottomRect = rect
            bottomRect.origin.y += move
            bottomRect.size.height -= move
            /// Reduce the height of the available retangle
            rect.size.height -= contentHeight
            /// Draw footer items
            for item in footer {
                item.draw(rect: &bottomRect, calculationOnly: calculationOnly, pageRect: pageRect)
            }
        }
    }
}

// MARK: Footer string styling

public extension StringAttributes {

    /// Style atributes for the footer
    static var footer: StringAttributes {
        [
            .foregroundColor: SWIFTColor.gray,
            .font: SWIFTFont.systemFont(ofSize: 8, weight: .regular)
        ]
    }
}

//
//  PDFBuild+PageHeader.swift
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

    /// A PDF pageheader item
    open class PageHeader: PDFElement {

        var top: [PDFElement]
        var bottom: [PDFElement]

        public init(top: [PDFElement], bottom: [PDFElement] = []) {
            self.top = top
            self.bottom = bottom
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            drawTop(rect: &rect, calculationOnly: calculationOnly)
            drawBottom(rect: &rect, calculationOnly: calculationOnly)
        }

        func drawTop(rect: inout CGRect, calculationOnly: Bool) {
            for item in top {
                item.draw(rect: &rect, calculationOnly: calculationOnly)
            }
        }

        func drawBottom(rect: inout CGRect, calculationOnly: Bool) {
            /// Calcukate bottom header size
            let tempRect = calculateDraw(rect: rect, elements: bottom)
            let move = tempRect.height
            let contentHeight = rect.height - move
            /// Draw bottom header
            var bottomRect = rect
            bottomRect.origin.y += move
            bottomRect.size.height -= move

            for item in bottom {
                item.draw(rect: &bottomRect, calculationOnly: calculationOnly)
            }

            rect.size.height -= contentHeight
        }
    }
}

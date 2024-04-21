//
//  PdfBuild+PageHeader.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PdfBuild {

    /// A PDF pageheader item
    open class PageHeader: PdfElement {

        var top: [PdfElement]
        var bottom: [PdfElement]

        public init(top: [PdfElement], bottom: [PdfElement] = []) {
            self.top = top
            self.bottom = bottom
        }

        open override func draw(rect: inout CGRect) {

            drawTop(rect: &rect)
            drawBottom(rect: &rect)
        }

        func drawTop(rect: inout CGRect) {

            let tempRect = estimateDraw(rect: rect, elements: top)

            var fillRect = builder?.fullPageRect ?? .zero
            fillRect.origin.y = rect.origin.y
            fillRect.size.height = rect.height - tempRect.height


            let context = UIGraphicsGetCurrentContext()
            context?.fill(fillRect)

            for item in top {
                item.draw(rect: &rect)
            }
        }

        func drawBottom(rect: inout CGRect) {
            /// Measure bottom header size
            let tempRect = estimateDraw(rect: rect, elements: bottom)

            let move = tempRect.height
            let contentHeight = rect.height - move

            /// Fill

            var fillRect = builder?.fullPageRect ?? .zero
            fillRect.origin.y = rect.origin.y + move
            fillRect.size.height = contentHeight


            let context = UIGraphicsGetCurrentContext()
            context?.fill(fillRect)

            /// Draw bottom header

            var bottomRect = rect
            bottomRect.origin.y += move
            bottomRect.size.height -= move

            for item in bottom {
                item.draw(rect: &bottomRect)
            }

            rect.size.height -= contentHeight
        }
    }
}

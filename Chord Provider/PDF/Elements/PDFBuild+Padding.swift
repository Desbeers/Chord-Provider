//
//  PDFBuild+Padding.swift
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

    /// A PDF padding item
    open class Padding: PDFElement {

        let size: CGFloat
        let element: PDFElement

        public init(size: CGFloat, _ element: PDFElement) {
            self.size = size
            self.element = element
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            var insetRect = rect.insetBy(dx: size, dy: size)

            element.draw(rect: &insetRect, calculationOnly: calculationOnly)
            let height = rect.height - insetRect.height
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

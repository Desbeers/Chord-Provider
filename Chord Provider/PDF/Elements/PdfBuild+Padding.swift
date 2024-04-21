//
//  PdfBuild+Padding.swift
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

    /// A PDF padding item
    open class Padding: PdfElement {

        let size: CGFloat
        let element: PdfElement

        public init(size: CGFloat, _ element: PdfElement) {
            self.size = size
            self.element = element
        }

        open override func draw(rect: inout CGRect) {
            var insetRect = rect.insetBy(dx: size, dy: size)

            element.draw(rect: &insetRect)
            let height = rect.height - insetRect.height
            rect.origin.y += height
            rect.size.height -= height
        }
    }
}

//
//  PdfBuild+Spacer.swift
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

    /// A PDF spacer item
    open class Spacer: PdfElement {

        var space: CGFloat

        public init(_ space: CGFloat = 5) {
            self.space = space
        }

        open override func draw(rect: inout CGRect) {
            rect.origin.y += space
            rect.size.height -= space
        }
    }
}

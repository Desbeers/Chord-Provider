//
//  PdfBuild+PageBreak.swift
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

    /// A PDF pagebreak item
    open class PageBreak: PdfElement {
        open override func shoudPageBreak(rect: CGRect) -> Bool {
            return true
        }
    }
}

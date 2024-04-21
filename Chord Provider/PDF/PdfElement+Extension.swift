//
//  PdfElement+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif


public extension PdfElement {

    func padding(_ size: CGFloat) -> PdfElement {
        PdfBuild.Padding(size: size, self)
    }

    func clipShape(_ shape: PdfBuild.Shape) -> PdfElement {
        PdfBuild.ClipShape(shape, self)
    }

    func modifier(_ item: PdfBuild.Modifier) -> PdfElement {
        return item.builder(self)
    }
}

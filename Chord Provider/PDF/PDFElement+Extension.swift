//
//  PDFElement+Extension.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif


public extension PDFElement {

    func padding(_ size: CGFloat) -> PDFElement {
        PDFBuild.Padding(size: size, self)
    }

    func clipShape(_ shape: PDFBuild.Shape) -> PDFElement {
        PDFBuild.ClipShape(shape, self)
    }

    func modifier(_ item: PDFBuild.Modifier) -> PDFElement {
        return item.builder(self)
    }
}

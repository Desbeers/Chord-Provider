//
//  PDFBuild+Modifier.swift
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

    /// A PDF text item
    open class Modifier {

        let builder: (PDFElement) -> PDFElement

        public init(_ builder: @escaping (PDFElement) -> PDFElement) {
            self.builder = builder
        }
    }
}

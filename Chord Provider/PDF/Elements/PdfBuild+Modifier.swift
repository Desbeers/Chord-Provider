//
//  PdfBuild+Modifier.swift
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

    /// A PDF text item
    open class Modifier {

        let builder: (PdfElement) -> PdfElement

        public init(_ builder: @escaping (PdfElement) -> PdfElement) {
            self.builder = builder
        }
    }
}

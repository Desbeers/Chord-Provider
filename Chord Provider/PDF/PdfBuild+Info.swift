//
//  PdfBuild+Info.swift
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

    struct Info {
        var title: String
        var author: String
        var subject: String = "Song lyrics and chords"
        var pdfCreator: String = "Chord Provider"

        var dictonary: [CFString : String] {
            [
                kCGPDFContextTitle: self.title,
                kCGPDFContextAuthor: self.author,
                kCGPDFContextSubject: self.subject,
                kCGPDFContextCreator: self.pdfCreator
            ]
        }
    }
}

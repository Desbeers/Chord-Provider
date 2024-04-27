//
//  PDFBuild+DocumentInfo.swift
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

    struct DocumentInfo {
        var title: String = ""
        var author: String = "Chord Provider"
        var subject: String = "Song lyrics and chords"
        var pdfCreator: String = "Chord Provider"
        let pageRect: CGRect = PDFBuild.a4portraitPage
        let pagePadding: CGFloat = PDFBuild.pagePadding

        var dictonary: [CFString: String] {
            [
                kCGPDFContextTitle: self.title,
                kCGPDFContextAuthor: self.author,
                kCGPDFContextSubject: self.subject,
                kCGPDFContextCreator: self.pdfCreator
            ]
        }
    }
}

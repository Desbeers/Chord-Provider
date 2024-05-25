//
//  PDFBuild+DocumentInfo.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension PDFBuild {

    // MARK: Information about the PDF document

    /// Information about the PDF document
    struct DocumentInfo {
        /// The title of the PDF document
        var title: String = ""
        /// The author of the PDF document
        var author: String = "Chord Provider"
        /// The subject of the PDF document
        var subject: String = "Song lyrics and chords"
        /// The creator of the PDF document
        var pdfCreator: String = "Chord Provider"
        /// The page size of the PDF document
        let pageRect: CGRect = PDFBuild.a4portraitPage
        /// The page padding of the PDF document
        let pagePadding: CGFloat = PDFBuild.pagePadding
        /// Metadata info for the PDF document
        var dictionary: [CFString: String] {
            [
                kCGPDFContextTitle: self.title,
                kCGPDFContextAuthor: self.author,
                kCGPDFContextSubject: self.subject,
                kCGPDFContextCreator: self.pdfCreator
            ]
        }
    }
}

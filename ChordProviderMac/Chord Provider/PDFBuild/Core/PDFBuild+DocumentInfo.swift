//
//  PDFBuild+DocumentInfo.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import AppKit

extension PDFBuild {

    // MARK: Information about the PDF document

    /// Information about the PDF document
    struct DocumentInfo {
        /// The title of the PDF document
        var title: String = ""
        /// The author of the PDF document
        var author: String = NSFullUserName()
        /// The subject of the PDF document
        var subject: String = "Song lyrics and chords"
        /// The creator of the PDF document
        var pdfCreator: String = "Chord Provider"
        /// The page size of the PDF document
        var pageRect: CGRect = CGRect()
        /// The page padding of the PDF document
        var pagePadding: CGFloat = 36
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

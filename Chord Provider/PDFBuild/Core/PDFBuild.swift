//
//  PDFBuild.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// A collection of bits and pieces to create a PDF
enum PDFBuild {

    // MARK: Static defaults

    /// A4 Portrait Page
    static let a4portraitPage = CGRect(x: 0, y: 0, width: 595, height: 842)

    /// A4 Landscape Page
    static let a4landscapePage = CGRect(x: 0, y: 0, width: 842, height: 595)

    /// The default padding for a page
    static let pagePadding: CGFloat = 36
}

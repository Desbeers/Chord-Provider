//
//  PDFBuild.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// A collection of bits and pieces to create a PDF from a ``Song``
public enum PDFBuild {

    // MARK: Static defaults

    /// A4 Portrait Page
    public static let a4portraitPage = CGRect(x: 0, y: 0, width: 612, height: 792)

    /// A4 Landscape Page
    public static let a4landscapePage = CGRect(x: 0, y: 0, width: 792, height: 612)

    /// The default padding for a page
    public static let pagePadding: CGFloat = 40
}

//
//  PDFBuild.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import OSLog

public enum PDFBuild {

    // MARK: Defaults

    /// A4 Portrait Page
    public static let a4portraitPage = CGRect(x: 0, y: 0, width: 612, height: 792)

    /// A4 Landscape Page
    public static let a4landscapePage = CGRect(x: 0, y: 0, width: 792, height: 612)

    /// The default padding for a page
    public static let pagePadding: CGFloat = 40
}

//
//  AppSettings+PDF.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension AppSettings {

    /// Settings for PDF
    struct PDF: Codable, Equatable {
        /// Page size
        var pageSize: PDFBuild.PageSize = .a4portrait
        /// Page padding
        var pagePadding: Double = 36
        /// Custom width
        var customWidth: Double = 1920
        /// Custom height
        var customHeight: Double = 1080
    }
}

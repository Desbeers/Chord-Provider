//
//  PDFBuild+PageSize.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// Page size options
    enum PageSize: String, CaseIterable, Codable {
        /// A4 portrait
        case a4portrait = "A4 portrait"
        /// A4 landscape
        case a4landscape = "A4 landscape"
        /// A5 portrait
        case a5portrait = "A5 portrait"
        /// A5 landscape
        case a5landscape = "A5 landscape"
        /// Custom size
        case custom = "Custom Size"
        /// The page size as `CGRect
        /// - Parameter settings: The application settings
        /// - Returns: The page size as `CGRect`
        func rect(settings: AppSettings) -> CGRect {
            switch self {
            case .a4portrait:
                CGRect(x: 0, y: 0, width: 595, height: 842)
            case .a4landscape:
                CGRect(x: 0, y: 0, width: 842, height: 595)
            case .a5portrait:
                CGRect(x: 0, y: 0, width: 420, height: 595)
            case .a5landscape:
                CGRect(x: 0, y: 0, width: 595, height: 420)
            case .custom:
                CGRect(x: 0, y: 0, width: settings.pdf.customWidth, height: settings.pdf.customHeight)
            }
        }
    }
}

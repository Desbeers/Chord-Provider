//
//  PDFBuild+TOCInfo.swift
//  Chord Provider

import Foundation

public extension PDFBuild {

    /// Information about an item for the TOC
    struct TOCInfo {
        /// The title of the TOC item
        public var title: String
        /// The subtitle of the TOC item
        public var subtitle: String
        /// The page number in the PDF
        public var pageNumber: Int = 0
        /// The rectangle of TOC entry
        /// - Note: Used to make internal links
        public var rect: CGRect = .zero
    }
}

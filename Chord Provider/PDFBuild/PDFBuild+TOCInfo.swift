//
//  PDFBuild+TOCInfo.swift
//  Chord Provider

import Foundation

public extension PDFBuild {

    // MARK: Information about an item for the Table of Contents

    /// Information about an item for the Table of Contents
    struct TOCInfo {
        /// The ID of the TOC item
        let id: UUID
        /// The title of the TOC item
        public var title: String
        /// The subtitle of the TOC item
        public var subtitle: String
        /// The page number in the PDF
        public var pageNumber: Int = 0
        /// The TOC page number
        public var tocPageNumber: Int = 0
        /// The rectangle of TOC entry
        /// - Note: Used to make internal links
        public var rect: CGRect = .zero
        /// The URL of the item
        public var fileURL: URL?
    }
}

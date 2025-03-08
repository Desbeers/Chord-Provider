//
//  PDFBuild+TOCInfo.swift
//  Chord Provider

import Foundation

extension PDFBuild {

    // MARK: Information about an item for the Table of Contents

    /// Information about an item for the Table of Contents
    struct TOCInfo {
        /// The ID of the TOC item
        var id: UUID {
            song.id
        }
        /// The song
        let song: Song
        /// The page number in the PDF
        var pageNumber: Int = 0
        /// The TOC page number
        var tocPageNumber: Int = 0
        /// The rectangle of TOC entry
        /// - Note: Used to make internal links
        var rect: CGRect = .zero
    }
}

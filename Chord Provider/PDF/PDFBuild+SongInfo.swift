//
//  PDFBuild+SongInfo.swift
//  Chord Provider

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension PDFBuild {

    struct SongInfo: Hashable {

        public func hash(into hasher: inout Hasher) {
            hasher.combine(page)
        }

        public var title: String
        public var artist: String
        /// The page in the PDF
        public var page: Int
        /// The coordinates of TOC entry
        /// - Note: Used to make internal links
        public var toc: CGRect = .zero
    }
}

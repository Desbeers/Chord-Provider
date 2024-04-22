//
//  PdfBuild+SongInfo.swift
//  Chord Provider

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension PdfBuild {

    struct SongInfo: Hashable {
        public var title: String
        public var artist: String
        public var page: Int
    }
}

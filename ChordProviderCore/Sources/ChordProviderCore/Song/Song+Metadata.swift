//
//  Song+Metadata.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure for metadata about the song

    /// Structure for metadata about the song
    public struct Metadata: Equatable, Codable, Sendable {

        /// Init the metadata with default values
        public init() {}

        // MARK: Metadata directives

        /// The title
        public var title: String = "No title"
        /// Sorting name of the title
        public var sortTitle: String = ""
        /// The artist
        public var artist: String = "Unknown Artist"
        /// Sorting name of the artist
        public var sortArtist: String = ""
        /// The optional composers
        /// - Note: Optional `array` so protected from appending directly
        private(set) public var composers: [String.ElementWrapper]?
        /// The optional subtitle
        public var subtitle: String?
        /// The optional capo
        public var capo: String?
        /// The optional key
        public var key: ChordDefinition?
        /// The optional tempo
        public var tempo: String?
        /// The optional time
        public var time: String?
        /// The optional year
        public var year: String?
        /// The optional album
        public var album: String?
        /// The optional URL to the audio file
        public var audioURL: URL?
        /// The optional URL to the video file
        public var videoURL: URL?
        /// The optional tag(s)
        /// - Note: Optional `array` so protected from appending directly
        private(set) public var tags: [String.ElementWrapper]?
        /// The optional duration
        public var duration: String?
        /// The optional copyright
        public var copyright: String?
        /// The optional arranger(s)
        /// - Note: Optional `array` so protected from appending directly
        private(set) public var arrangers: [String.ElementWrapper]?
        /// The optional lyricist(s)
        /// - Note: Optional `array` so protected from appending directly
        private(set) public var lyricists: [String.ElementWrapper]?
        /// The optional transpose
        public var transpose: Int = 0
        /// The longest label in the song
        /// - Note: Used in PDF output to calculate label offset
        public var longestLabel: String = ""
        /// The longest line the song
        /// - Note: Used in the PDF and SwiftUI output
        public var longestLine = Song.Section.Line()

        // MARK: Metadata directives that are defined

        /// An set of defined directives that only should be set once
        /// - Note: Used in the directive menus to disable *once only* directives
        public var definedMetadata: Set<String> = []

        // MARK: Song export

        /// The default name for the export
        public var exportName: String {
            "\(artist) - \(title)"
        }

        // MARK: Setters
        // Below are all optional `Array`'s
        // You cannot just append them because that will fail if the `Array` is empty.

        /// Add a *tag*
        /// - Parameter tag: The tag
        mutating func addTag(_ tag: String?) {
            if let tag, (tags?.append(.init(content: tag))) == nil {
                tags = [.init(content: tag)]
            }
        }

        /// Add a *arranger*
        /// - Parameter arranger: The arranger
        mutating func addArranger(_ arranger: String?) {
            if let arranger, (arrangers?.append(.init(content: arranger))) == nil {
                arrangers = [.init(content: arranger)]
            }
        }

        /// Add a *lyricist*
        /// - Parameter lyricist: The lyricist
        mutating func addLyricist(_ lyricist: String?) {
            if let lyricist, (lyricists?.append(.init(content: lyricist))) == nil {
                lyricists = [.init(content: lyricist)]
            }
        }

        /// Add a *composer*
        /// - Parameter lyricist: The lyricist
        mutating func addComposer(_ composer: String?) {
            if let composer, (composers?.append(.init(content: composer))) == nil {
                composers = [.init(content: composer)]
            }
        }

        // MARK: Formatters

        /// Format a duration given as "300" or "3:20" into "Xm Ys"
        public var formatDuration: String? {
            /// Duration is *optional*
            guard let duration else { return nil }

            let totalSeconds: Int

            /// Parse duration
            if duration.contains(":") {
                let parts = duration.split(separator: ":")
                guard
                    parts.count == 2,
                    let minutes = Int(parts[0]),
                    let seconds = Int(parts[1]),
                    seconds >= 0 && seconds < 60
                else { return nil }

                totalSeconds = minutes * 60 + seconds
            } else {
                guard let seconds = Int(duration), seconds >= 0 else { return nil }
                totalSeconds = seconds
            }

            /// Format output
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60

            switch (minutes, seconds) {
            case (0, 0):
                return "0s"
            case (0, _):
                return "\(seconds)s"
            case (_, 0):
                return "\(minutes)m"
            default:
                return "\(minutes)m \(seconds)s"
            }
        }
    }
}

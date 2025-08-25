//
//  Song+Metadata.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    // MARK: The structure for metadata about the song

    /// Structure for metadata about the song
    public struct Metadata: Equatable, Codable {
        public init(title: String = "No title", sortTitle: String = "", artist: String = "Unknown Artist", sortArtist: String = "", composers: [String]? = nil, subtitle: String? = nil, capo: String? = nil, key: ChordDefinition? = nil, tempo: String? = nil, time: String? = nil, year: String? = nil, album: String? = nil, audioURL: URL? = nil, videoURL: URL? = nil, tags: [String]? = nil, transpose: Int = 0, instrument: Chord.Instrument = .guitar, fileURL: URL? = nil, templateURL: URL? = nil, longestLabel: String = "", longestLine: Song.Section.Line = Song.Section.Line(), definedMetadata: Set<String> = []) {
            self.title = title
            self.sortTitle = sortTitle
            self.artist = artist
            self.sortArtist = sortArtist
            self.composers = composers
            self.subtitle = subtitle
            self.capo = capo
            self.key = key
            self.tempo = tempo
            self.time = time
            self.year = year
            self.album = album
            self.audioURL = audioURL
            self.videoURL = videoURL
            self.tags = tags
            self.transpose = transpose
            self.instrument = instrument
            self.fileURL = fileURL
            self.templateURL = templateURL
            self.longestLabel = longestLabel
            self.longestLine = longestLine
            self.definedMetadata = definedMetadata
        }

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
        public var composers: [String]?
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
        public var tags: [String]?
        /// The optional transpose
        public var transpose: Int = 0
        /// The instrument for the song
        public var instrument: Chord.Instrument = .guitar

        // MARK: URL's

        /// The optional file URL
        public var fileURL: URL?

        /// The optional template URL
        public var templateURL: URL?

        /// The longest label in the song
        /// - Note: Used in PDF output to calculate label offset
        public var longestLabel: String = ""
        /// The longest line the song
        /// - Note: Used in the PDF and SwiftUI output
        public var longestLine = Song.Section.Line()

        // MARK: Meta data directives that are defined

        /// An set of defined directives that only should be set once
        /// - Note: Used in the directive menus to disable *once only* directives
        public var definedMetadata: Set<String> = []

        // MARK: Song export

        /// The default name for the export
        public var exportName: String {
            "\(artist) - \(title)"
        }
    }
}

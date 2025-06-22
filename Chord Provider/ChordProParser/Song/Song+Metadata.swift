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
    struct Metadata: Equatable, Codable {

        // MARK: Meta-data directives

        /// The title
        var title: String = "No title"
        /// Sorting name of the title
        var sortTitle: String = ""
        /// The artist
        var artist: String = "Unknown Artist"
        /// Sorting name of the artist
        var sortArtist: String = ""
        /// The optional composers
        var composers: [String]?
        /// The optional subtitle
        var subtitle: String?
        /// The optional capo
        var capo: String?
        /// The optional key
        var key: ChordDefinition?
        /// The optional tempo
        var tempo: String?
        /// The optional time
        var time: String?
        /// The optional year
        var year: String?
        /// The optional album
        var album: String?
        /// The optional URL to the audio file
        var audioURL: URL?
        /// The optional URL to the video file
        var videoURL: URL?
        /// The optional tag(s)
        var tags: [String]?
        /// The optional transpose
        var transpose: Int = 0

        // MARK: URL's

        /// The optional file URL
        var fileURL: URL?

        /// The optional template URL
        var templateURL: URL?

        /// The temporary directory URL for processing files
        /// - Note: In its own directory so easier to debug
        var temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent("ChordProviderTMP", isDirectory: true)

        /// The URL of the source file
        var sourceURL: URL {
            /// Create a source URL
            return temporaryDirectoryURL.appendingPathComponent(exportName, conformingTo: .chordProSong)
        }

        /// The URL of the export PDF
        var exportURL: URL {
            /// Create an export URL
            return temporaryDirectoryURL.appendingPathComponent(exportName, conformingTo: .pdf)
        }

        /// The longest label in the song
        /// - Note: Used in PDF output to calculate label offset
        var longestLabel: String = ""
        /// The longest line the song
        var longestLine: String = ""

        // MARK: Meta data directives that are defined

        /// An set of defined directives that only should be set once
        /// - Note: Used in the directive menus to disable *once only* directives
        var definedMetadata: Set<String> = []

        // MARK: Song export

        /// The default name for the export
        var exportName: String {
            "\(artist) - \(title)"
        }
    }
}

extension Song.Metadata {
}

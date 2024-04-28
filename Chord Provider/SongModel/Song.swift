//
//  Song.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The structure of a song in `Chord Provider`
struct Song {

    var id: UUID = UUID()

    // MARK: Meta-data directives

    /// The optional title
    var title: String?
    /// The optional artist
    var artist: String?
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
    /// The optional tuning
    var tuning: String?
    /// The optional path to the audio file
    var musicPath: String?
    /// The optional tag(s)
    var tags: [String] = []
    /// The optional transpose
    var transpose: Int = 0
    /// The instrument
    var instrument: Instrument
    /// The optional file URL
    var fileURL: URL?

    // MARK: Song export

    /// The location for the PDF export
    var exportURL: URL {
        return FileManager.default.temporaryDirectory
            .appendingPathComponent(exportName)
            .appendingPathExtension("pdf")
    }

    /// The default name for the export
    var exportName: String {
        "\(artist ?? "Artist") - \(title ?? "Title")"
    }

    // MARK: All the sections in the song

    /// The sections of the song
    var sections = [Song.Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    var chords: [ChordDefinition] = []
}

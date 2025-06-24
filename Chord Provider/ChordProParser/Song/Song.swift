//
//  Song.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a song as shown in **Chord Provider**
struct Song: Equatable, Codable, Identifiable {

    static let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent(Bundle.main.bundleIdentifier ?? "nl.desbeers.chordprovider", isDirectory: true)

    /// The ID of the song
    var id: UUID

    /// The raw content of the song
    var content: String = ""

    /// Bool if the song has actual content
    var hasContent: Bool = true

    /// The total lines of the song
    var lines: Int = 0

    // MARK: Settings

    /// The application settings
    var settings = AppSettings()

    // MARK: Metadata directives

    /// The metadata about the ``Song``
    var metadata = Metadata()

    // MARK: All the sections in the song

    /// The sections of the song
    var sections = [Song.Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    var chords: [ChordDefinition] = []

    // MARK: Search

    /// Search
    var search: String {
        "\(metadata.title) \(metadata.artist)"
    }
}

//
//  Song.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a song as shown in **Chord Provider**
struct Song: Equatable, Codable, Identifiable {

    /// The ID of the song
    var id: UUID

    /// The raw content of the song
    var content: String = ""

    /// The total lines of the song
    var lines: Int = 0

    // MARK: Display options

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

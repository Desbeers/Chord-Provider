//
//  Song.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a song as shown in **Chord Provider**
public struct Song: Equatable, Codable, Identifiable, Sendable {
    public init(
        id: UUID,
        content: String = "",
        hasContent: Bool = true,
        lines: Int = 0,
        metadata: Song.Metadata = Metadata(),
        sections: [Song.Section] = [Song.Section](),
        chords: [ChordDefinition] = []
    ) {
        self.id = id
        self.content = content
        self.hasContent = hasContent
        self.lines = lines
        self.metadata = metadata
        self.sections = sections
        self.chords = chords
    }

    public static let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent(Bundle.main.bundleIdentifier ?? "nl.desbeers.chordprovider", isDirectory: true)

    /// The ID of the song
    public var id: UUID

    /// The raw content of the song
    public var content: String = ""

    /// Bool if the song has actual content
    public var hasContent: Bool = true

    /// Bool if the song has warnings or errors
    public var hasWarnings: Bool = false

    /// The total lines of the song
    var lines: Int = 0

    // MARK: Settings

    /// The ``ChordProviderSettings`` for the song
    public var settings = ChordProviderSettings()

    // MARK: Metadata directives

    /// The metadata about the ``Song``
    public var metadata = Metadata()

    // MARK: All the sections in the song

    /// The sections of the song
    public var sections = [Song.Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    public var chords: [ChordDefinition] = []

    // MARK: Transposing

    /// The total transposing; core setting + optional metadata
    public var transposing: Int {
        settings.transpose + metadata.transpose
    }

    // MARK: Search

    /// Search
    public var search: String {
        "\(metadata.title) \(metadata.artist)"
    }
}

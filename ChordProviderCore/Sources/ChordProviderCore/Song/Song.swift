//
//  Song.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a song as shown in **Chord Provider**
public struct Song: Equatable, Codable, Identifiable, Sendable {

    /// Init the song
    /// - Parameters:
    ///   - id: The ID of the song
    ///   - content: The content of the song
    public init(
        id: UUID,
        content: String = ""
    ) {
        self.id = id
        self.content = content
    }

    /// The ID of the song
    public var id: UUID

    /// The source of the song
    public var content: String = ""

    /// Bool if the song has actual content
    /// - Note: This will be set by the parser
    public var hasContent: Bool = false

    /// Bool if the song has warnings or errors
    public var hasWarnings: Bool = false

    /// The total lines of the song
    public var lines: Int = 0

    // MARK: Settings

    /// The ``ChordProviderSettings`` for the song
    public var settings = ChordProviderSettings()

    // MARK: Metadata directives

    /// The metadata about the ``Song``
    public var metadata = Metadata()

    // MARK: All the sections in the song

    /// The sections of the song
    public var sections = [Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    public var chords = [ChordDefinition]()

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

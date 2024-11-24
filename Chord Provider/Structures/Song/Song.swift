//
//  Song.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// The structure of a song as shown in **Chord Provider**
struct Song: Codable {

    /// The ID of the song
    var id: UUID

    /// The total lines of the song
    var lines: Int = 0

    // MARK: Display options

    /// The settings for the ``Song`` in the Document
    var settings = AppSettings.Song()

    // MARK: Metadata directives

    /// The metadata about the ``Song``
    var metadata = Metadata()

    // MARK: Meta data directives that are defined

    /// An array of defined directives that only should be set once
    /// - Note: Used in the directive menus to disable *once only* directives
    var definedMetaData: [ChordPro.Directive] = []

    // MARK: All the sections in the song

    /// The sections of the song
    var sections = [Song.Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    var chords: [ChordDefinition] = []
}

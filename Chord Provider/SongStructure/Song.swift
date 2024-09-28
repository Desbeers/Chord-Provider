//
//  Song.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The structure of a song as shown in **Chord Provider**
struct Song {

    /// The ID of the song
    var id: UUID = UUID()

    // MARK: Display options

    /// The display options for the ``Song``
    var displayOptions = DisplayOptions()

    // MARK: Meta data directives

    /// The meta data about the ``Song``
    var metaData = MetaData()

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

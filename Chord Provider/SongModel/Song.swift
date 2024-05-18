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

    /// The ID of the song
    var id: UUID = UUID()

    // MARK: Meta data directives

    var meta = MetaData()

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

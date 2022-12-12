//
//  Song.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The structure of a song in `Chord Provider`
struct Song {

    // MARK: Meta-data directives

    /// The optional title
    var title: String?
    /// The optional artist
    var artist: String?
    /// The optional capo
    var capo: String?
    /// The optional key
    var key: Chords.Key?
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
    /// The optional path of the ChordPro file
    var path: URL?
    /// The optional path to the audio file
    var musicpath: URL?
    /// The optional transpose
    var transpose: Int = 0

    // MARK: All the sections in the song

    /// The sections of the song
    var sections = [Song.Section]()

    // MARK: All the chords in the song

    /// The chords of the song
    var chords = [Chord]()
}

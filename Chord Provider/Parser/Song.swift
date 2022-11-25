//
//  Song.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftyChords

/// The struct of a song
struct Song {
    var title: String?
    var artist: String?
    var capo: String?
    var key: Chords.Key?
    var tempo: String?
    var time: String?
    var year: String?
    var album: String?
    var tuning: String?
    var path: URL?
    var musicpath: URL?
    var sections = [Song.Section]()
    var chords = [Chord]()
    var transpose: Int = 0
}

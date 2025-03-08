//
//  SongListSort.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

enum SongListSort: String, CaseIterable, Codable, Identifiable {
    /// Identifiable protocol
    var id: String {
        "\(self.rawValue)"
    }
    /// Sort list by song
    case song = "Sort by Song"
    /// Sort list by artist
    case artist = "Sort by Artist"
}

//
//  AppSettings+SongListSort.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {

    /// Options to sort a song by artist of title
    /// - Note: Used in PDF folder output
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
}

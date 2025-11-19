//
//  AppState+Recent.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Add a recent song
    /// - Parameter song: The parsed song
    mutating func addRecentSong(song: Song) {
        if let fileURL = song.settings.fileURL {
            /// Keep only relevant information
            var recent = Song(id: UUID())
            recent.metadata = song.metadata
            recentSongs.append(RecentSong(url: fileURL, song: song, lastOpened: Date.now))
        }
        /// Update the list
        recentSongs = Array(recentSongs.uniqued(by: \.id).sorted(using: KeyPathComparator(\.lastOpened, order: .reverse)).prefix(20))
    }

    /// Clear recent songs list
    mutating func clearRecentSongs() {
        self.recentSongs = []
    }

    /// Get recent songs
    func getRecentSongs() -> [RecentSong] {
        var recent: [RecentSong] = []
        for song in self.recentSongs where FileManager.default.fileExists(atPath: song.url.path) {
            recent.append(song)
        }
        /// Return to the `View`
        return recent
    }


    struct RecentSong: Codable, Hashable, Identifiable {
        var id: String {
            url.absoluteString
        }
        let url: URL
        let song: Song
        let lastOpened: Date
        /// Make the structure hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

}

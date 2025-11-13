//
//  AppSettings+App.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppSettings {
    
    /// Settings for all **Chord Provider** scenes
    struct App: Codable {
        /// The songs folder
        var songsFolder: URL?
        /// The selected tab on the welcome view
        var welcomeTab: Views.Welcome.ViewSwitcherView = .recent
        /// The zoom factor
        var zoom: Double = 1
        /// The width of the window
        var width = 800
        /// The height of the window
        var height = 600
        /// Recent songs
        private(set) var recentSongs: [RecentSong] = []

        /// Add a recent song
        /// - Parameter fileURL: The file URL of the song
        mutating func addRecentSong(fileURL: URL) {
            if let song = try? SongFileUtils.parseSongFile(
                        fileURL: fileURL,
                        settings: ChordProviderSettings(),
                        getOnlyMetadata: true
                    ) {
                var recent = self.recentSongs
                recent.removeAll { $0.url == fileURL }
                recent.insert(RecentSong(
                    url: fileURL,
                    title: song.metadata.title,
                    artist: song.metadata.artist
                ), at: 0)
                self.recentSongs = Array(recent.prefix(100))
            }
        }

        /// Clear recent songs list
        mutating func clearRecentSongs() {
            self.recentSongs = []
        }

        /// Get recent songs
        func getRecentSongs() -> [RecentSong] {
            var recent: [RecentSong] = []
            for song in self.recentSongs {
                if FileManager.default.fileExists(atPath: song.url.path) {
                    recent.append(song)
                }
            }
            return recent
        }
    }
}
extension AppSettings {

    /// Recent Song
    struct RecentSong: Identifiable, Codable {
        /// The ID of the URL
        var id = UUID()
        /// The URL
        var url: URL
        /// The title
        var title: String
        /// The artist
        var artist: String
    }
}

//
//  AppSettings+App.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension AppSettings {
    
    /// Settings for all **Chord Provider** scenes
    struct App: Codable {
        /// The songs folder
        var songsFolder: String = "/Users/Desbeers/Library/Mobile Documents/com~apple~CloudDocs/Chord Provider"
        /// The selected tab on the welcome view
        var welcomeTab: WelcomeView.ViewSwitcherView = .recent
        /// The zoom factor
        var zoom: Double = 1
        /// Recent songs
        private(set) var recentSongs: [URLElement] = []

        /// Add a recent song
        /// - Parameter fileURL: The file URL of the song
        mutating func addRecentSong(fileURL: URL) {
            var recent = self.recentSongs
            recent.removeAll { $0.url == fileURL }
            recent.insert(URLElement(url: fileURL), at: 0)
            self.recentSongs = Array(recent.prefix(100))
        }

        /// Clear recent songs list
        mutating func clearRecentSongs() {
            self.recentSongs = []
        }
    }
}

//
//  AppState+recent.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    /// Add a *Recent song*
    /// - Note: This will be the current song in the editor
    mutating func addRecentSong() {
        if let fileURL = self.editor.song.settings.fileURL {
            var recentSongs = self.recentSongs
            /// Keep only relevant information
            let recent = ChordProParser.parse(
                song: Song(id: UUID(), content: self.scene.originalContent),
                settings: self.editor.song.settings,
                getOnlyMetadata: true
            )
            recentSongs.append(
                RecentSong(
                    url: fileURL,
                    song: recent,
                    lastOpened: Date.now,
                    settings: self.editor.song.settings
                )
            )
            /// Update the list
            self.recentSongs = Array(
                recentSongs
                    .sorted(using: KeyPathComparator(\.lastOpened, order: .reverse))
                    .uniqued(by: \.id)
                    .prefix(20)
            )
        }
    }

    /// Clear the *Recent songs* list
    mutating func clearRecentSongs() {
        self.recentSongs = []
    }

    /// Get *Recent songs*
    func getRecentSongs() -> [RecentSong] {
        var recent: [RecentSong] = []
        /// Check if the file still exists
        for song in self.recentSongs where FileManager.default.fileExists(atPath: song.url.path) {
            recent.append(song)
        }
        /// Return to the `View`
        return recent
    }
}

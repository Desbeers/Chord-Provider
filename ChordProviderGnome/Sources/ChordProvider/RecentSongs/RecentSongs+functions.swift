//
//  RecentSongs+functions.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension RecentSongs {

    /// Add a *Recent song*
    mutating func addRecentSong(content: String, settings: ChordProviderSettings) {
        if let fileURL = settings.fileURL {
            var recentSongs = self.items
            /// Keep only relevant information
            let recent = ChordProParser.parse(
                song: Song(id: UUID(), content: content),
                settings: settings,
                getOnlyMetadata: true
            )
            recentSongs.append(
                Item(
                    url: fileURL,
                    settings: settings,
                    metadata: recent.metadata,
                    lastOpened: Date.now
                )
            )
            /// Update the list
            self.items = Array(
                recentSongs
                    .sorted(using: KeyPathComparator(\.lastOpened, order: .reverse))
                    .uniqued(by: \.id)
                    .prefix(20)
            )
        }
    }

    /// Clear the *Recent songs* list
    mutating func clearRecentSongs() {
        self.items = []
    }

    /// Get *Recent songs*
    func getRecentSongs() -> [Item] {
        var recent: [Item] = []
        /// Check if the file still exists
        for item in self.items where FileManager.default.fileExists(atPath: item.url.path) {
            recent.append(item)
        }
        /// Return to the `View`
        return recent
    }
}

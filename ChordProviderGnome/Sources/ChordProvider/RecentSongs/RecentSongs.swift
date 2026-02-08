//
//  RecentSongs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

struct RecentSongs: Codable {
    /// The list of recent songs
    var items: [Item] = []
}


extension RecentSongs {

    /// The structure for a recent song item
    struct Item: Codable, Hashable, Identifiable {
        /// The ID of the song
        var id: String {
            url.absoluteString
        }
        /// The URL of the song
        let url: URL
        /// The settings of the song
        let settings: ChordProviderSettings
        /// The metadata of the song
        let metadata: Song.Metadata
        /// Date when the song was last opened
        let lastOpened: Date
        /// Confirm to `hashable`
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

}

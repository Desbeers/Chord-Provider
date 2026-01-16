//
//  AppState+RecentSong.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {
    
    /// The structure for a recent song
    struct RecentSong: Codable, Hashable, Identifiable {
        /// The ID of the song
        var id: String {
            url.absoluteString
        }
        /// The URL of the song
        let url: URL
        /// The song itself; metadata only
        let song: Song
        /// Date when the song was last opened
        let lastOpened: Date
        /// The core settings when the song was opened
        let settings: ChordProviderSettings
        /// Confirm to `hashable`
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

}

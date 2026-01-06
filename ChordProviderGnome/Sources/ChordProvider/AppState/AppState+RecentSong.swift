//
//  AppState+RecentSong.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension AppState {

    struct RecentSong: Codable, Hashable, Identifiable {
        var id: String {
            url.absoluteString
        }
        let url: URL
        let song: Song
        let lastOpened: Date
        let settings: ChordProviderSettings
        /// Make the structure hashable
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

}

//
//  AppState+Home.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension AppState {

    /// Settings for the Home `View`
    struct Home: Codable {

        /// Sorting of the group
        var groupSort: SongFileUtils.Group = .artist
        /// The groupings browser
        var groupings: [SongFileUtils.Grouping] = []
        /// Random song
        var randomSong: Song?
        /// The tags browser
        var tags: [String.ElementWrapper] = []
        /// The selected tag
        var selectedTag: String.ElementWrapper.ID = .init()
        /// The tab to show on the Home `View`
        var tab: Tab = .mySongs
        /// The songs folder
        var songsFolder: URL?
    }
}
extension AppState.Home {

    /// Items to store in the database
    enum CodingKeys: String, CodingKey {
        /// Sorting of a group
        case groupSort
        /// The folder with songs
        case songsFolder
    }
}

extension AppState.Home {

    /// The tabs on the Home `View`
    enum Tab: String, CaseIterable, CustomStringConvertible, Codable {
        /// My songs
        case mySongs = "My Songs"
        /// My tags
        case myTags = "My Tags"
        /// Recent songs
        case recentSongs = "Recent Songs"
        /// The id of the tab
        var id: Self { self }
        /// The description of the tab
        var description: String {
            rawValue
        }
        /// The icon of the tab
        var icon: Icon? {
            .default(icon: {
                switch self {
                case .mySongs:
                    .documentOpen
                case .myTags:
                    .userBookmarks
                case .recentSongs:
                    .documentOpenRecent
                }
            }())
        }
        /// Bool to show the label
        var showLabel: Bool { true }
    }
}

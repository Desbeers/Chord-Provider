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
        /// The songs browser
        var songs: [Song] = []
        /// The song browser
        var searchResult: [Song] = []
        /// Random song
        var randomSong: Song?
        /// The tags browser
        var tags: [String.ElementWrapper] = []
        /// The selected tag
        var selectedTag: String.ElementWrapper.ID = .init()
        /// The library state
        /// - Note: For the song browser
        var libraryState: LibraryState = .loading
        /// The tab to show on the Home `View`
        var tab: Tab = .mySongs
        /// Bool to show the grouping toggles
        var showGrouping: Bool = true
        /// The optional search string
        var search: String = "" {
            didSet {
                doSearch()
            }
        }
        /// The songs folder
        var songsFolder: URL?
    }
}
extension AppState.Home {

    /// Items to store in the database
    enum CodingKeys: String, CodingKey {
        case groupSort
        case songsFolder
    }
}

extension AppState.Home {

    /// Set the search results
    mutating func doSearch() {
        if search.isEmpty {
            showGrouping = true
            libraryState = .loaded
        } else {
            showGrouping = false
            searchResult = songs.filter { song in
                song.search.localizedCaseInsensitiveContains(search)
            }
            libraryState = searchResult.isEmpty ? .emptySearch : .searchResults
        }
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

extension AppState.Home {

    /// The state of the song library
    enum LibraryState: String {
        /// Library is loading
        case loading
        /// Library is loaded
        case loaded
        /// Library has an error
        case error
        /// Show the search results
        case searchResults
        /// Empty search results
        case emptySearch
        /// No library folder selected
        case noLibrarySelected
    }
}

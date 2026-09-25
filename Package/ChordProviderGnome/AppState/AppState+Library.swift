//
//  LibraryController.swift
//  ChordProviderEditor
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderEditor

/// The state of the library

extension AppState {

    /// The songs library
    struct Library {

        /// The songs browser
        var songs: [Song] = []
        /// Bool to show the grouping toggles
        var showGrouping: Bool = true
        /// The library state
        var state: State = .loading
        /// The optional search string
        var search: String = ""
        /// The search results
        var searchResult: [Song] = []

        /// Do the search
        mutating func doSearch() {
            if search.isEmpty {
                showGrouping = true
                state = .loaded
            } else {
                showGrouping = false
                searchResult = songs.search(search)
                self.state = self.searchResult.isEmpty ? .emptySearch : .searchResults
            }
        }

        /// The state of the song library
        enum State: String {

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
}

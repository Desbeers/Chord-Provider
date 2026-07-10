//
//  AppState+helpers.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension AppState {

    /// Set a random song from the library
    mutating func setRandomSong() {
        home.randomSong = home.songs.randomElement()
    }

    /// Get the content of a folder with songs
    mutating func getFolderContent() {
        if let url = home.songsFolder {
            home.songs = SongFileUtils.getSongsFromFolder(
                url: url,
                settings: editor.coreSettings,
                getOnlyMetadata: true
            )
            groupSongs()
            /// Don't show tags with links; they are very specific for the song
            let tags = home
                .songs
                .compactMap(\.metadata.tags)
                .flatMap(\.self)
                .filter { element in
                    !element.content.contains("http")
                }

            /// Make sure the tags are unique
            home.tags = tags.uniqued(by: \.content).sorted()

            /// The songs are loaded
            home.libraryState = home.songs.isEmpty ? .error : .loaded
            if home.libraryState == .loaded {
                home.showGrouping = true
                setRandomSong()
            }
        } else {
            home.showGrouping = false
            home.libraryState = .noLibrarySelected
        }
    }

    /// Group the songs by a metadata item
    mutating func groupSongs() {
        home.groupings = SongFileUtils.groupSongs(
            home.songs,
            group: home.groupSort,
            sortTokens: editor.coreSettings.sortTokens
        )
    }
}

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
        home.randomSong = library.songs.randomElement()
    }

    /// Get the content of a folder with songs
    mutating func getFolderContent() {
        if let url = home.songsFolder {
            library.songs = SongFileUtils.getSongsFromFolder(
                url: url,
                settings: editor.coreSettings,
                getOnlyMetadata: true
            )
            groupSongs()
            /// Don't show tags with links; they are very specific for the song
            let tags = library
                .songs
                .compactMap(\.metadata.tags)
                .flatMap(\.self)
                .filter { element in
                    !element.content.contains("http")
                }

            /// Make sure the tags are unique
            home.tags = tags.uniqued(by: \.content).sorted()

            /// The songs are loaded
            library.state = library.songs.isEmpty ? .error : .loaded
            if library.state == .loaded {
                library.showGrouping = true
                setRandomSong()
            }
        } else {
            library.showGrouping = false
            library.state = .noLibrarySelected
        }
    }

    /// Group the songs by a metadata item
    mutating func groupSongs() {
        home.groupings = SongFileUtils.groupSongs(
            library.songs,
            group: home.groupSort,
            sortTokens: editor.coreSettings.sortTokens
        )
    }
}

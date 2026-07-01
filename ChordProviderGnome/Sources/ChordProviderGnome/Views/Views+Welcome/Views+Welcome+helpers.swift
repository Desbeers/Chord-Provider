//
//  Views+Welcome+helpers.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

// MARK: Helper functions

extension Views.Welcome {

    /// Open a sample song from the application bundle
    /// - Parameters:
    ///   - sample: The sample song
    ///   - showEditor: Bool to show the editor
    func openSample(_ sample: Utils.Samples, showEditor: Bool) {
        appState.openSample(sample, showEditor: showEditor)
        setRandomSong()
    }

    /// Set a random song from the library
    func setRandomSong() {
        randomSong = songs.randomElement()
    }

    // MARK: Get folder content
    /// Get the content of a folder with songs
    func getFolderContent() {
        Idle {
            if let url = songsFolder {
                let content = SongFileUtils.getSongsFromFolder(
                    url: url,
                    settings: appState.editor.coreSettings,
                    getOnlyMetadata: true
                )
                artists = content.artists
                songs = content.songs
                /// Don't show tags with links; they are very specific for the song
                let tags = songs.compactMap(\.metadata.tags).flatMap(\.self).filter { !$0.content.contains("http") }

                /// Make sure the tags are unique
                self.tags = tags.uniqued(by: \.content).sorted()

                setRandomSong()
                /// The songs are loaded
                loadingState = songs.isEmpty ? .error : .loaded
            } else {
                loadingState = .error
            }
        }
    }
}

extension Views.Welcome {

    // MARK: Welcome Tabs

    /// The tabs on the Welcome View
    enum WelcomeTab: String, CaseIterable, CustomStringConvertible, Codable {
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

extension Views.Welcome {

    // MARK: Open Button

    /// Open a song
    /// - Parameters:
    ///   - fileURL: The URL of the song
    ///   - metadata: The metadata of the song
    ///   - songTitleOnly: Show only the song title
    ///   - showTags: Show the optional t
    /// - Returns: A `Body`
    func openButton(
        fileURL: URL,
        metadata: Song.Metadata,
        songTitleOnly: Bool = false,
        showTags: Bool = true
    ) -> AnyView {
        HStack {
            Button("") {
                appState.openSong(fileURL: fileURL)
                recentSongs.addRecentSong(
                    content: appState.scene.originalContent,
                    coreSettings: appState.editor.coreSettings
                )
                setRandomSong()
                appState.scene.showToast.signal()
            }
            .child {
                HStack {
                    VStack {
                        Text(metadata.title)
                            .halign(.start)
                            .style(songTitleOnly ? .plainButton : .subtitle)
                            .hexpand()
                        if !songTitleOnly {
                            Text(metadata.artist)
                                .halign(.start)
                                .style(.plainButton)
                        }
                    }
                    .valign(.center)
                }
                .valign(.center)
                .frame(minWidth: songTitleOnly ? 0 : 300)
            }
            .hasFrame(false)
            .tooltip(fileURL.lastPathComponent.escapeSpecialCharacters)
            if showTags, let tags = metadata.tags {
                Views.Tags(tags: tags)
                    .valign(.center)
            }
        }
    }
}

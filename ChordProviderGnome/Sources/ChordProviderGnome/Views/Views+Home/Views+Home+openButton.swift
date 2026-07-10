//
//  Views+Home+openButton.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Home {

    /// Button to open a song
    /// - Parameters:
    ///   - fileURL: The URL of the song
    ///   - metadata: The metadata of the song
    ///   - songTitleOnly: Show only the song title
    ///   - showTags: Show the optional tags
    /// - Returns: An `AnyView`
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
                appState.scene.showToast.signal()
            }
            .child {
                VStack {
                    Text(metadata.title)
                        .halign(.start)
                        .hexpand()
                    if !songTitleOnly {
                        Text(metadata.artist)
                            .halign(.start)
                            .style(.plainButton)
                    }
                }
                .valign(.center)
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

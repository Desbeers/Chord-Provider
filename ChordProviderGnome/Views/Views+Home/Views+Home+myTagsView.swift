//
//  Views+Home+myTagsView.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita

extension Views.Home {

    // MARK: Tags View

    /// The `View` with *My Tags* content
    var myTagsView: AnyView {
        VStack(spacing: 20) {
            if appState.home.tags.isEmpty {
                StatusPage(
                    "Your songs have no tags",
                    icon: .default(icon: .userBookmarks)
                )
                .frame(minWidth: 350)
                .vexpand()
            } else {
                NavigationSplitView {
                    List(
                        appState.home.tags,
                        selection: $appState.home.selectedTag,
                    ) { element in
                        Text(element.content)
                            .halign(.start)
                            .padding()
                    }
                } content: {
                    let selection = appState.home.tags.first { element in
                        element.id.uuidString == appState.home.selectedTag.datatypeValue
                    }
                    let songs = appState.home.songs.filter { song in
                        song.metadata.tags?.map(\.content).contains(selection?.content ?? "") ?? false
                    }
                    ScrollView {
                        if songs.isEmpty {
                            StatusPage(
                                "Select a Tag",
                                icon: .default(icon: .userBookmarks),
                                description: "Select a Tag to display its songs."
                            )
                            .frame(minWidth: 350)
                        } else {
                            VStack {
                                ForEach(songs) { song in
                                    if let fileURL = song.settings.fileURL {
                                        openButton(fileURL: fileURL, metadata: song.metadata)
                                    }
                                }
                            }
                            .frame(minWidth: 350)
                            .frame(maxWidth: 350)
                            .hexpand()
                        }
                    }
                    .vexpand()
                }
                .padding()
                .vexpand()
            }
        }
        .vexpand()
        .card()
    }
}

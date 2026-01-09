//
//  Views.Welcome+myTags.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views.Welcome {

    // MARK: Tags View

    /// The `View` with *My Tags* content
    @ViewBuilder var myTags: Body {
        VStack(spacing: 20) {
            if tags.isEmpty {
                StatusPage(
                    "Your songs have no tags",
                    icon: .default(icon: .userBookmarks)
                )
                .frame(minWidth: 350)
                .vexpand()
            } else {
                NavigationSplitView {
                    List(tags, selection: $selectedTab) { element in
                        Text(element.content)
                            .halign(.start)
                            .padding()
                    }
                } content: {
                    let selection = tags.first(where:  {$0.id.uuidString == selectedTab.datatypeValue } )
                    let songs = songs.filter { $0.metadata.tags?.contains(selection?.content ?? "") ?? false }
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
                                        openButton(fileURL: fileURL, song: song)
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

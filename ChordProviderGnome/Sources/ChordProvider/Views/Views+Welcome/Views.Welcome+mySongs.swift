//
//  Views.Welcome+mySongs.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita

extension Views.Welcome {

    // MARK: My Songs View

    /// The `View` with *My Songs* content
    @ViewBuilder var mySongs: Body {
        VStack {
            ScrollView {
                HStack {
                    if loadingState != .loaded {
                        StatusPage(
                            loadingState == .error ? "No folder selected." : "Loading songs",
                            icon: .default(icon: .folderMusic),
                            description: loadingState == .error ? "You have not selected a folder with your songs." : "One moment..."
                        )
                        .frame(minWidth: 350)
                        .transition(.crossfade)
                    } else if search.isEmpty {
                        FlowBox(artists) { artist in
                            VStack {
                                Text(artist.name)
                                    .style(.subtitle)
                                    .halign(.start)
                                Separator()
                                VStack {
                                    ForEach(artist.songs) { song in
                                        if let url = song.settings.fileURL {
                                            openButton(fileURL: url, song: song, songTitleOnly: true)
                                        }
                                    }
                                }
                            }
                        }
                        .rowSpacing(10)
                        .columnSpacing(10)
                        .transition(.crossfade)
                    } else {
                        let result = songs.filter { $0.search.localizedCaseInsensitiveContains(search) }
                        if result.isEmpty {
                            StatusPage(
                                "No songs found",
                                icon: .default(icon: .systemSearch),
                                description: "Oops! We couldn't find any songs that match your search."
                            )
                            .frame(minWidth: 350)
                            .transition(.crossfade)
                        } else {
                            VStack(spacing: 10) {
                                ForEach(result) { song in
                                    if let fileURL = song.settings.fileURL {
                                        openButton(fileURL: fileURL, song: song)
                                    }
                                }
                            }
                            .transition(.crossfade)
                        }
                    }
                }
                .halign(.center)
                .padding()
            }
            .card()
            .vexpand()
        }
    }
}

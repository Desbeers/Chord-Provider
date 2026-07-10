//
//  Views+Home+mySongsView.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore

extension Views.Home {

    // MARK: My Songs View

    /// The `View` with *My Songs* content
    var mySongsView: AnyView {
        ScrollView {
            Box {
                switch appState.home.libraryState {
                case .loading:
                    StatusPage(
                        "Loading songs",
                        icon: .default(icon: .folderMusic),
                        description: "One moment..."
                    )
                    .frame(minWidth: 350)
                case .loaded:
                    mySongsGroupView
                case .error:
                    StatusPage(
                        "No songs found",
                        icon: .default(icon: .systemSearch),
                        description: "Oops! We couldn't find any songs in your folder."
                    )
                    .frame(minWidth: 350)
                case .searchResults:
                    mySongsSearchView
                case .emptySearch:
                    StatusPage(
                        "No songs found",
                        icon: .default(icon: .systemSearch),
                        description: "Oops! We couldn't find any songs that match your search."
                    )
                    .frame(minWidth: 350)
                case .noLibrarySelected:
                    StatusPage(
                        "No folder selected.",
                        icon: .default(icon: .folderMusic),
                        description: "You have not selected a folder with your songs."
                    )
                    .frame(minWidth: 350)
                }
            }
            .transition(.crossfade)
            .id(appState.home.libraryState.rawValue)
            .padding(.horizontal)
            .topToolbar(visible: appState.home.showGrouping) {
                ToggleGroup(
                    selection: $appState.home.groupSort.onSet { _ in
                        appState.groupSongs()
                    },
                    values: SongFileUtils.Group.allCases,
                    id: \.self,
                    label: \.rawValue
                )
                .halign(.center)
                .style(.homeSongsSortToggle)
                .padding()
            }
        }
        .card()
        .vexpand()
    }

    /// The `View` with grouped songs
    var mySongsGroupView: AnyView {
        FlowBox(appState.home.groupings) { artist in
            VStack {
                Text(artist.name)
                    .style(.subtitle)
                    .halign(.start)
                Separator()
                ForEach(artist.songs) { song in
                    if let url = song.settings.fileURL {
                        openButton(
                            fileURL: url,
                            metadata: song.metadata,
                            songTitleOnly: appState.home.groupSort == .artist ? true : false
                        )
                    }
                }
            }
        }
        .rowSpacing(10)
        .columnSpacing(10)
        .transition(.crossfade)
        .id(appState.home.groupSort.rawValue)
    }

    /// The `View` with search results
    var mySongsSearchView: AnyView {
        VStack(spacing: 10) {
            HStack {
                Symbol(icon: .default(icon: .systemSearch))
                    .padding()
                Text("Searching for '<i>\(appState.home.search)</i>'")
                    .useMarkup()
            }
            .style(.title)
            .hexpand()
            .halign(.center)
            ForEach(appState.home.searchResult) { song in
                if let fileURL = song.settings.fileURL {
                    openButton(fileURL: fileURL, metadata: song.metadata)
                }
            }
            .halign(.center)
        }
        .hexpand()
        .frame(minWidth: appState.home.libraryState == .loaded ? 0 : 400)
    }
}

//
//  WelcomeView+browserFiles.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

extension WelcomeView {

    @ViewBuilder var browserFiles: some View {
        @Bindable var fileBrowser = fileBrowser
        VStack {
            switch fileBrowser.status {
            case .noSongsFolderSelectedError:
                VStack {
                    Text("Your Songs")
                        .font(.title)
                        .padding()
                    Text(.init(Help.fileBrowser))
                        .padding()
                    fileBrowser.folderSelector
                        .buttonStyle(.bordered)
                        .labelStyle(.titleAndIcon)
                    Text("You can always select a new folder in the **Settings**.")
                        .font(.footnote)
                        .padding()
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            case .songsFolderIsSelected:
                Picker("Menu", selection: $fileBrowser.tabItem) {
                    ForEach(FileBrowserModel.TabItem.allCases, id: \.rawValue) { item in
                        Text(item.rawValue)
                            .tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .disabled(!fileBrowser.search.isEmpty)
                .task(id: fileBrowser.tabItem) {
                    fileBrowser.selectedTag = []
                }
                NavigationStack(path: $fileBrowser.selectedTag.animation(.easeInOut)) {
                    List {
                        if fileBrowser.search.isEmpty {
                            switch fileBrowser.tabItem {
                            case .artists:
                                artistsList
                            case .songs:
                                songsList
                            case .tags:
                                tagsList
                            }
                        } else {
                            ForEach(
                                fileBrowser.songList.filter { $0.search.localizedCaseInsensitiveContains(fileBrowser.search) }
                            ) { song in
                                songRow(song: song, showArtist: true)
                            }
                        }
                    }
                    .searchable(text: $fileBrowser.search, placement: .sidebar)
                    .opacity(fileBrowser.selectedTag.isEmpty ? 1 : 0)
                    .navigationDestination(for: String.self) { tag in
                        List {
                            Section(
                                header:
                                    HStack {
                                        Button {
                                            fileBrowser.selectedTag = []
                                        } label: {
                                            Image(systemName: "chevron.backward")
                                                .bold()
                                                .foregroundStyle(.primary)
                                        }
                                        Text("Songs with '\(tag)' tag").font(.headline)
                                    }
                            ) {
                                ForEach(fileBrowser.songList.filter { $0.tags.contains(tag) }) { song in
                                    songRow(song: song, showArtist: true)
                                }
                            }
                        }
                    }
                }
            default:
                // swiftlint:disable:next force_unwrapping
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .scaledToFit()
            }
        }
        .scrollContentBackground(.hidden)
        .animation(.default, value: fileBrowser.status)
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .task(id: fileBrowser.songList) {
            fileBrowser.getFiles()
            let tags = fileBrowser.songList.flatMap(\.tags)
            /// Make sure the tags are unique
            fileBrowser.allTags = Array(Set(tags).sorted())
        }
        .onChange(of: fileBrowser.songsFolder) {
            fileBrowser.songList = []
            fileBrowser.getFiles()
            let tags = fileBrowser.songList.flatMap(\.tags)
            /// Make sure the tags are unique
            fileBrowser.allTags = Array(Set(tags).sorted())
        }
    }
    /// Artists list `View`
    var artistsList: some View {
        ForEach(fileBrowser.artistList) { artist in
            Section(header: Text(artist.name).font(.headline)) {
                ForEach(artist.songs) { song in
                    songRow(song: song)
                }
            }
        }
    }
    /// Songs list `View`
    var songsList: some View {
        Section(header: Text("All Songs").font(.headline)) {
            ForEach(fileBrowser.songList) { song in
                songRow(song: song, showArtist: true)
            }
        }
    }
    /// Tags list `View`
    var tagsList: some View {
        Section(header: Text("All Tags").font(.headline)) {
            ForEach(fileBrowser.allTags) { tag in
                Button(
                    action: {
                        fileBrowser.selectedTag.append(tag)
                    },
                    label: {
                        Label(tag, systemImage: "tag")
                    }
                )
            }
        }
    }
}

extension WelcomeView {

    func songRow(song: FileBrowserModel.SongItem, showArtist: Bool = false) -> some View {
        Button(
            action: {
                Task {
                    await openSong(url: song.fileURL)
                }
            },
            label: {
                Label(
                    title: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(song.title)
                                    .foregroundStyle(.primary)
                                if showArtist {
                                    Text(song.artist)
                                        .foregroundStyle(.secondary)
                                }
                                if !song.tags.isEmpty {
                                    Text(song.tags.joined(separator: "∙"))
                                        .foregroundStyle(.tertiary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    },
                    icon: {
                        Image(systemName: "music.note")
                            .foregroundStyle(Color.accent)
                    }
                )
            }
        )
        .contextMenu {
            Button(
                action: {
                    song.fileURL.openInFinder()
                },
                label: {
                    Text("Open song in Finder")
                }
            )
        }
        .buttonStyle(.plain)
    }
}

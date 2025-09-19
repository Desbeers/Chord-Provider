//
//  WelcomeView+browserFiles.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

extension WelcomeView {

    /// A `View` to browse files from a user selected folder
    @ViewBuilder var browserFiles: some View {
        /// Bind the observable file browser class
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
                .padding(.top)
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
                                fileBrowser.songs.filter { $0.search.localizedCaseInsensitiveContains(fileBrowser.search) }
                            ) { song in
                                songRow(song: song, showArtist: true)
                            }
                        }
                    }
                    .searchable(text: $fileBrowser.search)
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
                                ForEach(fileBrowser.songs.filter { $0.metadata.tags?.contains(tag) ?? false }) { song in
                                    songRow(song: song, showArtist: true)
                                }
                            }
                        }
                    }
                }
            default:
                ZStack {
                    ImageUtils.applicationIcon()
                        .resizable()
                        .scaledToFit()
                    ProgressView()
                }
            }
        }
        .scrollContentBackground(.hidden)
        .animation(.default, value: fileBrowser.status)
        .task(id: fileBrowser.songs) {
            if fileBrowser.songs.isEmpty {
                fileBrowser.getFiles()
            }
            let tags = fileBrowser.songs.compactMap(\.metadata.tags).flatMap { $0 }
            /// Make sure the tags are unique
            fileBrowser.allTags = Array(Set(tags).sorted())
        }
        .onChange(of: fileBrowser.songsFolder) {
            fileBrowser.songs = []
            fileBrowser.getFiles()
            let tags = fileBrowser.songs.compactMap(\.metadata.tags).flatMap { $0 }
            /// Make sure the tags are unique
            fileBrowser.allTags = Array(Set(tags).sorted())
        }
    }
    /// Artists list `View`
    var artistsList: some View {
        ForEach(fileBrowser.artists) { artist in
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
            ForEach(fileBrowser.songs) { song in
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

    /// A `View` with a single song
    /// - Parameters:
    ///   - song: The song
    ///   - showArtist: Bool if the artist should be shown in the row view
    /// - Returns: A `View` for the song
    func songRow(song: Song, showArtist: Bool = false) -> some View {
        Button(
            action: {
                Task {
                    if let url = song.metadata.fileURL {
                        await openSong(url: url)
                    }
                }
            },
            label: {
                Label(
                    title: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(song.metadata.title)
                                    .foregroundStyle(.primary)
                                if showArtist {
                                    Text(song.metadata.artist)
                                        .foregroundStyle(.secondary)
                                }
                                if let tags = song.metadata.tags {
                                    Text(tags.joined(separator: "∙"))
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
        .listRowSeparator(.hidden)
        .contextMenu {
            Button(
                action: {
                    if let url = song.metadata.fileURL {
                        url.openInFinder()
                    }
                },
                label: {
                    Text("Open song in Finder")
                }
            )
        }
        .buttonStyle(.plain)
    }
}

//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the file browser
@MainActor struct FileBrowserView: View {
    /// The observable ``FileBrowser`` class
    @State private var fileBrowser = FileBrowserModel.shared
    /// The search query
    @State var search: String = ""
    /// Tab item
    @State private var tabItem: TabItem = .artists
    /// All tags
    @State private var allTags: [String] = []
    /// Selected tag
    @State private var selectedTag: [String] = []
    /// The body of the `View`
    var body: some View {
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
                    Spacer()
                    Text(.init(Help.musicPath))
                        .font(.caption)
                        .padding()
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            case .songsFolderIsSelected:
                Picker("Menu", selection: $tabItem) {
                    ForEach(TabItem.allCases, id: \.rawValue) { item in
                        Text(item.rawValue)
                            .tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .disabled(!search.isEmpty)
                .task(id: tabItem) {
                    selectedTag = []
                }
                NavigationStack(path: $selectedTag.animation(.easeInOut)) {
                    List {
                        if search.isEmpty {
                            switch tabItem {
                            case .artists:
                                artistsList
                            case .songs:
                                songsList
                            case .tags:
                                tagsList
                            }
                        } else {
                            ForEach(
                                fileBrowser.songList.filter { $0.search.localizedCaseInsensitiveContains(search) }
                            ) { song in
                                Row(song: song, showArtist: true)
                            }
                        }
                    }
                    .searchable(text: $search, placement: .sidebar)
                    .opacity(selectedTag.isEmpty ? 1 : 0)
                    .navigationDestination(for: String.self) { tag in
                        List {
                            Section(
                                header:
                                    HStack {
                                        Button {
                                            selectedTag = []
                                        } label: {
                                            Image(systemName: "chevron.backward")
                                                .bold()
                                                .foregroundStyle(.primary)
                                        }
                                        Text("Songs with '\(tag)' tag").font(.headline)
                                    }
                            ) {
                                ForEach(fileBrowser.songList.filter { $0.tags.contains(tag) }) { song in
                                    Row(song: song, showArtist: true)
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
        .buttonStyle(.plain)
        .task(id: fileBrowser.songList) {
            fileBrowser.getFiles()
            let tags = fileBrowser.songList.flatMap(\.tags)
            /// Make sure the tags are unique
            allTags = Array(Set(tags).sorted())
        }
        .onChange(of: fileBrowser.songsFolder) {
            fileBrowser.songList = []
            fileBrowser.getFiles()
            let tags = fileBrowser.songList.flatMap(\.tags)
            /// Make sure the tags are unique
            allTags = Array(Set(tags).sorted())
        }
    }

    /// Artists list `View`
    var artistsList: some View {
        ForEach(fileBrowser.artistList) { artist in
            Section(header: Text(artist.name).font(.headline)) {
                ForEach(artist.songs) { song in
                    Row(song: song)
                }
            }
        }
    }
    /// Songs list `View`
    var songsList: some View {
        Section(header: Text("All Songs").font(.headline)) {
            ForEach(fileBrowser.songList) { song in
                Row(song: song, showArtist: true)
            }
        }
    }
    /// Tags list `View`
    var tagsList: some View {
        Section(header: Text("All Tags").font(.headline)) {
            ForEach(allTags) { tag in
                Button(
                    action: {
                        selectedTag.append(tag)
                    },
                    label: {
                        Label(tag, systemImage: "tag")
                    }
                )
            }
        }
    }
    /// Tab bar items
    enum TabItem: String, CaseIterable {
        /// Artists
        case artists = "Artists"
        /// Songs
        case songs = "Songs"
        /// Tags
        case tags = "Tags"
    }
}

extension FileBrowserView {

    /// SwiftUI `View` for a row in the browser list
    @MainActor struct Row: View {
        /// The song item
        let song: FileBrowserModel.SongItem
        /// Show the artist or not
        var showArtist: Bool = false
        /// The observable ``FileBrowser`` class
        @State private var fileBrowser = FileBrowserModel.shared
        /// Information about the `NSWindow`
        var window: NSWindow.WindowItem? {
            fileBrowser.openWindows.first { $0.fileURL == song.fileURL }
        }
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task {
                        await fileBrowser.openSong(url: song.fileURL)
                    }
                },
                label: {
                    Label(
                        title: {
                            VStack(alignment: .leading) {
                                Text(song.title)
                                    .foregroundStyle(.primary)
                                if showArtist {
                                    Text(song.artist)
                                        .foregroundStyle(.secondary)
                                }
                                if !song.tags.isEmpty {
                                    Text(song.tags.joined(separator: "∙"))
                                        //.foregroundStyle(controlActiveState == .key ? .tertiary : .quaternary)
                                }
                            }
                        },
                        icon: {
                            Image(systemName: song.musicPath.isEmpty ? "music.note" : "music.note.list")
                                .foregroundStyle(Color.accent)
                        }
                    )
                }
            )
            .contextMenu {
                Button(
                    action: {
                        UserFileBookmark.openInFinder(url: song.fileURL)
                    },
                    label: {
                        Text("Open song in Finder")
                    }
                )
            }
            /// Show an image when the song is open
            .background(alignment: .trailing) {
                Image(systemName: "macwindow")
                    .opacity(window == nil ? 0 : 1)
            }
        }
    }

    /// SwiftUI `LabelStyle` for a browser item
    struct BrowserLabelStyle: LabelStyle {

        /// Style the label
        /// - Parameter configuration: The configuration of the label
        /// - Returns: A `View` with the label
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon.foregroundColor(.accent).frame(width: 14)
                configuration.title
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

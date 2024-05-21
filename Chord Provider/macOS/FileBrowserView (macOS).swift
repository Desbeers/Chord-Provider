//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import OSLog
import SwiftlyFolderUtilities

/// SwiftUI `View` for the file browser
struct FileBrowserView: View {
    /// The FileBrowser model
    @Environment(FileBrowser.self) private var fileBrowser
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
        Group {
            switch fileBrowser.status {
            case .noSongsFolderSelectedError:
                VStack {
                    Text("Welcome to Chord Provider")
                        .font(.title)
                    SongFolderView()
                    Text(.init(Help.fileBrowser))
                        .padding(.vertical)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .navigationSubtitle("Welcome")
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
                            ForEach(fileBrowser.songList.filter { $0.search.localizedCaseInsensitiveContains(search) }) { song in
                                Row(song: song, showArtist: true)
                            }
                        }
                    }
                    .searchable(text: $search, placement: .sidebar)
                    .opacity(selectedTag.isEmpty ? 1 : 0)
                    .navigationDestination(for: String.self) { tag in
                        List {
                            Section(header: Text("Songs with '\(tag)' tag").font(.headline)) {
                                ForEach(fileBrowser.songList.filter { $0.tags.contains(tag) }) { song in
                                    Row(song: song, showArtist: true)
                                }
                            }
                        }
                    }
                }
                .navigationSubtitle("\(fileBrowser.songList.count) songs")
                .labelStyle(BrowserLabelStyle())
            default:
                Image(.launchIcon)
                    .resizable()
                    .scaledToFit()
                    .navigationSubtitle("Welcome")
            }
        }
        .scrollContentBackground(.hidden)
        .animation(.default, value: fileBrowser.status)
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .buttonStyle(.plain)
        .frame(width: 320)
        .frame(minHeight: 500)
        .background(Color.telecaster.opacity(0.2))
        .navigationTitle("Chord Provider")
        .toolbar {
            fileBrowser.folderSelector
        }
        .task(id: fileBrowser.songList) {
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
        case artists = "Artists"
        case songs = "Songs"
        case tags = "Tags"
    }
}

extension FileBrowserView {

    /// SwiftUI `View` for a row in the browser list
    struct Row: View {
        /// The song item
        let song: FileBrowser.SongItem
        /// Show the artist or not
        var showArtist: Bool = false
        /// The ``FileBrowser`` model
        @Environment(FileBrowser.self) private var fileBrowser
        /// Open documents in the environment
        @Environment(\.openDocument) private var openDocument
        /// Focus of the Window
        @Environment(\.controlActiveState) var controlActiveState
        /// Information about the `NSWindow`
        var window: NSWindow.WindowItem? {
            fileBrowser.openWindows.first { $0.fileURL == song.fileURL }
        }
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task { @MainActor in
                        await openSong(url: song.fileURL)
                    }
                },
                label: {
                    Label(
                        title: {
                            VStack(alignment: .leading) {
                                Text(song.title)
                                if showArtist {
                                    Text(song.artist)
                                        .foregroundStyle(.secondary)
                                }
                                if !song.tags.isEmpty {
                                    Text(song.tags.joined(separator: "∙"))
                                        .foregroundStyle(controlActiveState == .key ? .tertiary : .quaternary)
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
                        FolderUtil.openInFinder(url: song.fileURL)
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

        /// Open a new song window
        /// - Parameter url: The URL of the song
        @MainActor func openSong(url: URL) async {
            /// openDocument is very buggy; don't try to open a document when it is already open
            if let window {
                NSApp.window(withWindowNumber: window.windowID)?.makeKeyAndOrderFront(self)
            } else {
                /// Because this is running async we have to do the sandbox-stuff ourselfs
                /// instead of using the `FolderBookmark.action` method
                do {
                    if let persistentURL = try FolderBookmark.getPersistentFileURL(FileBrowser.folderBookmark) {
                        _ = persistentURL.startAccessingSecurityScopedResource()
                        try await openDocument(at: url)
                        persistentURL.stopAccessingSecurityScopedResource()
                    }
                } catch {
                    Logger.application.error("Error opening file: \(error.localizedDescription, privacy: .public)")
                }
            }
            /// If the browser is shown in a MenuBarExtra, close it
            fileBrowser.menuBarExtraWindow?.close()
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

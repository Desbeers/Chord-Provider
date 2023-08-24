//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities

/// SwiftUI `View` for the file browser
struct FileBrowserView: View {
    /// The FileBrowser model
    @EnvironmentObject var fileBrowser: FileBrowser
    /// The search query
    @State var search: String = ""
    /// The body of the `View`
    var body: some View {
        List {
            if search.isEmpty {
                ForEach(fileBrowser.artistList) { artist in
                    Section(header: Text(artist.name).font(.headline)) {
                        ForEach(fileBrowser.songList.filter { $0.artist == artist.name }) { song in
                            Row(song: song)
                        }
                    }
                }
            } else {
                ForEach(fileBrowser.songList.filter { $0.search.localizedCaseInsensitiveContains(search) }) { song in
                    VStack(alignment: .leading) {
                        Row(song: song)
                        Text(song.artist)
                            .font(.caption)
                    }
                }
            }
        }
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .labelStyle(BrowserLabelStyle())
        .buttonStyle(.plain)
        .frame(width: 320)
        .overlay(alignment: .center) {
            if !fileBrowser.folder {
                folderButton
                    .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Chord Provider")
        .navigationSubtitle("\(fileBrowser.songList.count) songs")
        .task {
            await fileBrowser.getFiles()
        }
        .searchable(text: $search, placement: .sidebar)
        .toolbar {
            folderButton
        }
    }
    /// Folder selection button
    var folderButton: some View {
        FolderBookmark.SelectFolder(
            bookmark: FileBrowser.bookmark,
            title: "Select a folder",
            systemImage: "folder"
        ) {
            Task { @MainActor in
                await fileBrowser.getFiles()
            }
        }
    }
}

extension FileBrowserView {

    /// SwiftUI `View` for a row in the browser list
    struct Row: View {
        /// The song item
        let song: FileBrowser.SongItem
        /// The ``FileBrowser`` model
        @EnvironmentObject var fileBrowser: FileBrowser
        /// Open documents in the environment
        @Environment(\.openDocument)
        private var openDocument
        /// Information about the `NSWindow`
        var window: NSWindow.WindowItem? {
            fileBrowser.openWindows.first { $0.fileURL == song.fileURL }
        }
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    openSong(url: song.fileURL)
                },
                label: {
                    Label(song.title, systemImage: song.musicPath.isEmpty ? "music.note" : "music.note.list")
                }
            )
            .contextMenu {
                Button(
                    action: {
                        FolderBookmark.openInFinder(url: song.fileURL)
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
        func openSong(url: URL) {
            /// openDocument is very buggy; don't try to open a document when it is already open
            if let window {
                NSApp.window(withWindowNumber: window.windowID)?.makeKeyAndOrderFront(self)
            } else {
                Task {
                    try? await FolderBookmark.action(bookmark: FileBrowser.bookmark) { _ in
                        try? await openDocument(at: song.fileURL)
                    }
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
                configuration.icon.foregroundColor(.accentColor).frame(width: 10)
                configuration.title
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

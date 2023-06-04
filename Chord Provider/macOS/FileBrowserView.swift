//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with a list of songs from a user selected directory
struct FileBrowserView: View {
    /// The FileBrowser model
    @EnvironmentObject var fileBrowser: FileBrowserModel
    /// The search query
    @State var search: String = ""
    /// The body of the `View`
    var body: some View {
        List {
            if search.isEmpty {
                ForEach(fileBrowser.artistList) { artist in
                    Section(header: Text(artist.name).font(.headline)) {
                        ForEach(fileBrowser.songList.filter({$0.artist == artist.name})) { song in
                            Row(song: song)
                        }
                    }
                }
            } else {
                ForEach(fileBrowser.songList.filter({ $0.search.localizedCaseInsensitiveContains(search)})) { song in
                    Row(song: song)
                }
            }
        }
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .labelStyle(BrowserLabelStyle())
        .buttonStyle(.plain)
        .frame(width: 320)
        .navigationTitle("Chord Provider")
        .navigationSubtitle("\(fileBrowser.songList.count) songs")
        .task {
            fileBrowser.getFiles()
        }
        .searchable(text: $search, placement: .sidebar)
        .toolbar {
            Button {
                fileBrowser.selectSongsFolder()
            } label: {
                Image(systemName: "folder")
            }
            .help("The folder with your songs")
        }
    }
}

extension FileBrowserView {

    /// SwiftUI `View` for a row in the browser list
    struct Row: View {
        /// The song item
        let song: FileBrowserModel.SongItem
        /// The ``FileBrowser`` model
        @EnvironmentObject var fileBrowser: FileBrowserModel
        /// Open documents in the environment
        @Environment(\.openDocument) private var openDocument
        /// Information about the `NSWindow`
        var window: FileBrowserModel.WindowItem? {
            fileBrowser.openWindows.first(where: {$0.songURL == song.path})
        }
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    /// openDocument is very buggy; don't try to open a document when it is already open
                    if let window {
                        NSApp.window(withWindowNumber: window.windowID)?.makeKeyAndOrderFront(self)
                    } else {
                        Task {
                            do {
                                /// Sandbox stuff
                                if var persistentURL = FolderBookmark.getPersistentFileURL("pathSongs") {
                                    dump(persistentURL)
                                    _ = persistentURL.startAccessingSecurityScopedResource()
                                    persistentURL = song.path
                                    try await openDocument(at: song.path)
                                    persistentURL.stopAccessingSecurityScopedResource()
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    /// If the browser is shown in a MenuBarExtra, close it
                    fileBrowser.menuBarExtraWindow?.close()
                },
                label: {
                    VStack {
                        Label(song.title, systemImage: song.musicpath.isEmpty ? "music.note" : "music.note.list")
                    }
                }
            )
            .contextMenu {
                Button {
                    FolderBookmark.openInFinder(url: song.path)
                } label: {
                    Text("Open song in Finder")
                }
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
                configuration.icon.foregroundColor(.accentColor).frame(width: 10)
                configuration.title
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

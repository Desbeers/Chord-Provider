//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The  View with a list of songs from a user selected directory
struct FileBrowserView: View {
    @EnvironmentObject var fileBrowser: FileBrowser
    @AppStorage("pathSongsString") var pathSongsString: String = FileBrowser.getDocumentsDirectory()
    @AppStorage("refreshList") var refreshList: Bool = false
    @State var search: String = ""
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
        /// - Note: Below is needed or else the serach filed will be hidden behind the toolbar
        .padding(.top, 1)
        .frame(width: 320)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Chord Provider")
        .navigationSubtitle("\(fileBrowser.songList.count) songs")
        .task {
            fileBrowser.getFiles()
        }
        .searchable(text: $search, placement: .sidebar)
        .toolbar {
            Button {
                fileBrowser.selectSongsFolder(fileBrowser)
            } label: {
                Image(systemName: "folder")
            }
            .help("The folder with your songs")
        }
        /// A dirty trick to refresh the list; when you save a document, this will be toggled
        .onChange(of: refreshList) { _ in
            Task { @MainActor in
                /// Give it a moment to save the file
                try await Task.sleep(nanoseconds: 1_000_000_000)
                fileBrowser.getFiles()
            }
        }
    }
}

extension FileBrowserView {

    /// A row in the browser list
    struct Row: View {
        /// The song item
        let song: FileBrowser.SongItem
        /// The ``FileBrowser`` model
        @EnvironmentObject var fileBrowser: FileBrowser
        /// Open documents in the environment
        @Environment(\.openDocument) private var openDocument
        /// Information about the `NSWindow`
        var window: FileBrowser.WindowItem? {
            fileBrowser.openWindows.first(where: {$0.songURL == song.path})
        }
        /// The View
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
                                if var persistentURL = FileBrowser.getPersistentFileURL("pathSongs") {
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
                    Label(song.title, systemImage: song.musicpath.isEmpty ? "music.note" : "music.note.list")            }
            )
            /// Show an image when the song is open
            .background(alignment: .trailing) {
                Image(systemName: "macwindow")
                    .opacity(window == nil ? 0 : 1)
            }
        }
    }

    /// Label style for a browser item
    struct BrowserLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            HStack {
                configuration.icon.foregroundColor(.accentColor).frame(width: 10)
                configuration.title
                Spacer()
            }
        }
    }
}

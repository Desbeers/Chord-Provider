//
//  FileBrowserView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// A  View with a list of songs from a user selected directory
struct FileBrowserView: View {
    @EnvironmentObject var mySongs: MySongs
    @AppStorage("pathSongsString") var pathSongsString: String = getDocumentsDirectory()
    @AppStorage("refreshList") var refreshList: Bool = false
    @State var search: String = ""
    var body: some View {
        List {
            if search.isEmpty {
                ForEach(mySongs.artistList) { artist in
                    Section(header: Text(artist.name).font(.headline)) {
                        ForEach(mySongs.songList.filter({$0.artist == artist.name})) { song in
                            Row(song: song)
                        }
                    }
                }
                
            } else {
                ForEach(mySongs.songList.filter({ $0.search.localizedCaseInsensitiveContains(search)})) { song in
                    Row(song: song)
                }
            }
        }
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .labelStyle(BrowserLabelStyle())
        .buttonStyle(BrowserButtonStyle())
        /// - Note: Below is needed or else the serach filed will be hidden behind the toolbar
        .padding(.top, 1)
        .frame(width: 320)
        .background(Color(NSColor.windowBackgroundColor))
        .navigationTitle("Chord Provider")
        .navigationSubtitle("\(mySongs.songList.count) songs")
        .task {
            mySongs.getFiles()
        }
        .searchable(text: $search, placement: .sidebar)
        .toolbar {
            Button {
                selectSongsFolder(mySongs)
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
                mySongs.getFiles()
            }
        }
    }
}

extension FileBrowserView {
    
    /// A row in the browser list
    struct Row: View {
        let song: SongItem
        
        @EnvironmentObject var mySongs: MySongs
        
        @Environment(\.openDocument) private var openDocument
        
        var body: some View {
            let rowImage = (song.musicpath.isEmpty ? "music.note" : "music.note.list")
            Button(
                action: {
                    Task {
                        do {
                            if var persistentURL = getPersistentFileURL("pathSongs") {
                                _ = persistentURL.startAccessingSecurityScopedResource()
                                persistentURL = song.path
                                try await openDocument(at: song.path)
                                persistentURL.stopAccessingSecurityScopedResource()
                            }
                        } catch {
                            print(error)
                        }
                    }
                },
                label: {
                    Label(song.title, systemImage: rowImage)            }
            )
            /// openDocument is very buggy; don't try to open a document when it is already open
            .disabled(mySongs.openFiles.contains(song.path))
        }
    }
}

// MARK: Style for an item in the browser

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

/// Button style for a Browser item
struct BrowserButtonStyle: ButtonStyle {
    /// The style
    func makeBody(configuration: Self.Configuration) -> some View {
        BrowserButtonStyleView(configuration: configuration)
    }
}

private extension BrowserButtonStyle {
    
    /// The view for the button style
    struct BrowserButtonStyleView: View {
        /// Tracks if the button is enabled or not
        @Environment(\.isEnabled) var isEnabled
        /// Tracks the pressed state
        let configuration: BrowserButtonStyle.Configuration
        /// The view
        var body: some View {
            return configuration.label
                .opacity(isEnabled ? 1 : 0.6)
                .brightness(configuration.isPressed ? 0.2 : 0)
                .background(alignment: .trailing, content: {
                    Image(systemName: "macwindow")
                        .opacity(isEnabled ? 0 : 1)
                })
                .cornerRadius(6)
        }
    }
}

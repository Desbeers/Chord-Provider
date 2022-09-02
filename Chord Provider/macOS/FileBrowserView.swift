// MARK: Sidebar for macOS

/// A sidebar view with a list of songs from a user selected directory

import SwiftUI

// MARK: Views

/// A  View with a list of songs from a user selected directory
struct FileBrowserView: View {
    @EnvironmentObject var mySongs: MySongs
    @AppStorage("pathSongsString") var pathSongsString: String = getDocumentsDirectory()
    @State var search: String = ""
    
    @AppStorage("refreshList") var refreshList: Bool = false
    
    var body: some View {
        
        List {
            if search.isEmpty {
                ForEach(mySongs.artistList) { artist in
                    Section(header: Text(artist.name).font(.headline)) {
                        ForEach(mySongs.songList.filter({$0.artist == artist.name})) { song in
                            FileBrowserRow(song: song)
                        }
                    }
                }
                
            } else {
                ForEach(mySongs.songList.filter({ $0.search.localizedCaseInsensitiveContains(search)})) { song in
                    FileBrowserRow(song: song)
                }
            }
        }
        /// It must be 'sidebar' or else the search field will not be added
        .listStyle(.sidebar)
        .labelStyle(LabelStyleBrowser())
        .buttonStyle(ButtonStyleBrowser())
        .searchable(text: $search, placement: .sidebar)
        .toolbar {
            Button {
                selectSongsFolder(mySongs)
            } label: {
                Image(systemName: "folder")
                    .foregroundColor(.secondary)
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
            print("Sidebar said hello!")
        }
    }
}

struct FileBrowserRow: View {
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

// MARK: - Style for an item in the sidebar

/// - Note: - This is a combination of Label and Button

/// Label style for a sidebar item
struct LabelStyleBrowser: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.foregroundColor(.accentColor).frame(width: 10)
            configuration.title
            Spacer()
        }
    }
}

/// Button style for a Browser item
struct ButtonStyleBrowser: ButtonStyle {
    /// The style
    func makeBody(configuration: Self.Configuration) -> some View {
        ViewButtonStyleSidebar(configuration: configuration)
    }
}

private extension ButtonStyleBrowser {
    
    /// The view for the button style in a list
    /// - Note: private extension becasue it is part of the 'ButtenStyleSidebar' ButtonStyle
    struct ViewButtonStyleSidebar: View {
        /// Tracks if the button is enabled or not
        @Environment(\.isEnabled) var isEnabled
        /// Tracks the pressed state
        let configuration: ButtonStyleBrowser.Configuration
        /// The view
        var body: some View {
            return configuration.label
                .padding(6)
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

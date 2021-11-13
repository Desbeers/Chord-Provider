// MARK: Sidebar for macOS

/// A sidebar view with a list of songs from a user selected directory

import SwiftUI

// MARK: Views

struct ViewSidebar: View {
    
    @Binding var document: ChordProDocument
    let file: URL?
    @StateObject var mySongs = MySongs()
    @AppStorage("pathSongsString") var pathSongsString: String = getDocumentsDirectory()
    @State var search: String = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List {
                    if search.isEmpty {
                        ForEach(mySongs.songList.artists) { artist in
                            Section(header: Text(artist.name)) {
                                ForEach(artist.songs) { song in
                                    FileBrowserRow(song: song, selection: (file?.lastPathComponent ?? "New"))
                                }
                            }
                        }
                    } else {
                        ForEach(mySongs.songList.artists) { artist in
                            ForEach(artist.songs.filter({ $0.search.localizedCaseInsensitiveContains(search)})) { song in
                                FileBrowserRow(song: song, selection: (file?.lastPathComponent ?? "New"))
                            }
                        }
                    }
                }
                .sidebarButtons()
                .searchable(text: $search, placement: .sidebar)
                .onAppear(
                    perform: {
                        proxy.scrollTo((file), anchor: .center)
                    }
                )
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                        }
                    label: {
                        Image(systemName: "sidebar.left")
                            .foregroundColor(.secondary)
                    }
                    .help("Hide or show the sidebar")
                        Button {
                            selectSongsFolder(mySongs)
                        }
                    label: {
                        Image(systemName: "folder")
                            .foregroundColor(.secondary)
                    }
                    .help("The folder with your songs")
                    }
                }
            }
        }
        .frame(minWidth: 200)
        .onChange(of: document.refreshList) { _ in
            self.mySongs.songList = GetSongsList()
            print("Sidebar said hello!")
        }
    }
}

struct FileBrowserRow: View {
    let song: ArtistSongs
    let selection: String
    
    var body: some View {
        let rowImage = (song.musicpath.isEmpty ? "music.note" : "music.note.list")
        Button(
            action: {
                openSong(song: song)
            },
            label: {
                Label(song.title, systemImage: rowImage)
            }
        )
            .disabled(selection == song.path.lastPathComponent ? true : false)
            .id(song.path)
    }
    
    func openSong(song: ArtistSongs) {
        NSWorkspace.shared.open(song.path)
        /// Sandbox stuff: get path for selected folder
        if var persistentURL = getPersistentFileURL("pathSongs") {
            _ = persistentURL.startAccessingSecurityScopedResource()
            persistentURL = song.path
            let configuration = NSWorkspace.OpenConfiguration()
            /// Find the location of the application:
            if let chordpro = Bundle.main.resourceURL?.baseURL {
                NSWorkspace.shared.open([persistentURL], withApplicationAt: chordpro, configuration: configuration)
            }
            persistentURL.stopAccessingSecurityScopedResource()
        }
    }
}

// MARK: - Style for an item in the sidebar

/// - Note: - This is a combination of Label and Button

/// Label style for a sidebar item
struct LabelStyleSidebar: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon.foregroundColor(.accentColor).frame(width: 10)
            configuration.title
            Spacer()
        }
    }
}

/// Button style for a sidebar item
struct ButtonStyleSidebar: ButtonStyle {
    /// The style
    func makeBody(configuration: Self.Configuration) -> some View {
        ViewButtonStyleSidebar(configuration: configuration)
    }
}

private extension ButtonStyleSidebar {
    
    /// The view for the button style in a list
    /// - Note: private extension becasue it is part of the 'ButtenStyleSidebar' ButtonStyle
    struct ViewButtonStyleSidebar: View {
        /// Tracks if the button is enabled or not
        @Environment(\.isEnabled) var isEnabled
        /// Tracks the pressed state
        let configuration: ButtonStyleSidebar.Configuration
        /// The view
        var body: some View {
            return configuration.label
                .padding(6)
                .brightness(configuration.isPressed ? 0.2 : 0)
                .background(isEnabled ?  Color.clear : Color.secondary.opacity(0.2))
                .cornerRadius(6)
        }
    }
}

/// Shortcut for the combined sidebar item style
struct SidebarButtons: ViewModifier {
    func body(content: Content) -> some View {
        content
            .labelStyle(LabelStyleSidebar())
            .buttonStyle(ButtonStyleSidebar())
    }
}

/// Extend View with a shortcut
extension View {
    /// Shortcut for sidebar buttons
    /// - Returns: A ``View`` modifier
    func sidebarButtons() -> some View {
        modifier(SidebarButtons())
    }
}

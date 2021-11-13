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
                SearchField(text: $search)
                    .padding(.horizontal, 10)
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 300))],
                        alignment: .center,
                        spacing: 4,
                        pinnedViews: [.sectionHeaders, .sectionFooters]
                    ) {
                        ForEach(mySongs.songList.artists) { artist in
                            Section(header: search.isEmpty ? ArtistHeader(artist: artist) : nil) {
                                ForEach(artist.songs.filter({search.isEmpty ? true : $0.search.localizedCaseInsensitiveContains(search)})) { song in
                                    FileBrowserRow(song: song, selection: (file?.lastPathComponent ?? "New"))
                                }
                            }
                        }
                    }
                }
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

struct ArtistHeader: View {
    let artist: ArtistList

    var body: some View {
        ZStack {
            FancyBackground()
                .opacity(0.9)
            VStack(spacing: 0) {
                HStack {
                    Text(artist.name)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 4)
                    Spacer()
                }
                Divider()
            }.padding(.horizontal, 10)
        }
    }
}

struct FileBrowserRow: View {
    let song: ArtistSongs
    let selection: String

    var body: some View {
        VStack {
            let rowImage = (song.musicpath.isEmpty ? "music.note" : "music.note.list")
            ZStack {
                if selection == song.path.lastPathComponent {
                    Color.secondary.cornerRadius(5).opacity(0.2)
                }
                HStack {
                    Label() {
                        Text(song.title).lineLimit(1)
                    } icon: {
                        Image(systemName: rowImage).foregroundColor(.accentColor)
                    }
                    Spacer()
                }
                .padding(.all, 4)
            }
        }
        .padding(.horizontal, 10)
        .onTapGesture {
            openSong(song: song)
        }
        .id(song.path)
    }
    
    func openSong(song: ArtistSongs) {
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

struct SearchField: NSViewRepresentable {
    @Binding var text: String
    func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSSearchField()
        searchField.delegate = context.coordinator
        searchField.placeholderString = "Artist or song"
        return searchField
    }
    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = text
    }
    func makeCoordinator() -> SearchField.Coordinator {
        Coordinator(parent: self)
    }
    class Coordinator: NSObject, NSSearchFieldDelegate {
        let parent: SearchField
        init(parent: SearchField) {
            self.parent = parent
        }
        func controlTextDidChange(_ notification: Notification) {
            guard let searchField = notification.object as? NSSearchField else {
                return
            }
            parent.text = searchField.stringValue
        }
    }
}

// MARK: Class and Structs

class MySongs: ObservableObject {
    @Published var songList = GetSongsList()
    func updateView() {
        self.objectWillChange.send()
    }
}

struct ArtistSongs: Identifiable {
    var id = UUID()
    var artist: String = "Unknown artist"
    var title: String = ""
    var search: String {
        return "\(title) \(artist)"
    }
    var musicpath: String = ""
    var path: URL
}

struct ArtistList: Identifiable {
    let id = UUID()
    let name: String
    let songs: [ArtistSongs]
}

struct GetSongsList {
    let artists: [ArtistList]
    /// Fill the list.
    init() {
        print("Getting songs from selected folder")
        /// Get the songs in the selected directory
        let songs = GetSongsList.getFiles()
        /// Use the Dictionary(grouping:) function so that all the artists are grouped together.
        let grouped = Dictionary(grouping: songs) { (occurrence: ArtistSongs) -> String in
            occurrence.artist
        }
        /// We now map over the dictionary and create our artist objects.
        /// Then we want to sort them so that they are in the correct order.
        self.artists = grouped.map { artist -> ArtistList in
            ArtistList(name: artist.key, songs: artist.value)
        }.sorted { $0.name < $1.name }
    }
    /// This is a helper function to get the files.
    static func getFiles() -> [ArtistSongs] {
        var songs = [ArtistSongs]()
        /// Get a list of all files
        
        if let persistentURL = getPersistentFileURL("pathSongs") {
            /// Sandbox stuff...
            _ = persistentURL.startAccessingSecurityScopedResource()
            if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if item.lastPathComponent.hasSuffix(".pro") {
                        var song = ArtistSongs(path: item)
                        parseSongFile(item, &song)
                        songs.append(song)
                    }
                }
            }
            persistentURL.stopAccessingSecurityScopedResource()
        }
        return songs.sorted { $0.title < $1.title }
    }
    /// This is a helper function to parse the song for metadata
    static func parseSongFile(_ file: URL, _ song: inout ArtistSongs) {
        song.title = file.lastPathComponent
        
        do {
            let data = try String(contentsOf: file, encoding: .utf8)
            
            for text in data.components(separatedBy: .newlines) {
                if (text.starts(with: "{")) {
                    parseFileLine(text: text, song: &song)
                }
            }
        } catch {
            print(error)
        }
    }
    /// This is a helper function to parse the actual metadata
    static func parseFileLine(text: String, song: inout ArtistSongs) {
        let directiveRegex = try? NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}")
        
        var key: String?
        var value: String?
        if let match = directiveRegex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: text) {
                key = text[keyRange].trimmingCharacters(in: .newlines)
            }

            if let valueRange = Range(match.range(at: 2), in: text) {
                value = text[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
            switch key {
            case "t":
                song.title = value!
            case "title":
                song.title = value!
            case "st":
                song.artist = value!
            case "subtitle":
                song.artist = value!
            case "artist":
                song.artist = value!
            case "musicpath":
                song.musicpath = value!
            default:
                break
            }
        }
    }
}

// MARK: Functions

// Folder selector
// ---------------

func selectSongsFolder(_ mySongs: MySongs) {
    let base = UserDefaults.standard.object(forKey: "pathSongsString") as? String ?? getDocumentsDirectory()
    let dialog = NSOpenPanel()
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseFiles = false
    dialog.canChooseDirectories = true
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your songs"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { result in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            /// Save the url so next time this dialog is opened it will go to this folder.
            /// Sandbox stuff seems to be ok with that....
            UserDefaults.standard.set(result!.path, forKey: "pathSongsString")
            /// Create a persistent bookmark for the folder the user just selected
            _ = setPersistentFileURL("pathSongs", result!)
            /// Refresh the list of songs
            mySongs.songList = GetSongsList()
        }
    }
}

// GetDocumentsDirectory()
// -----------------------
// Returns the users Documents directory.
// Used when no folders are selected by the user.

func getDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

// Get and Set sandbox bookmarks
// -----------------------------
// Many thanks to https://www.appcoda.com/mac-apps-user-intent/

func setPersistentFileURL(_ key: String, _ selectedURL: URL) -> Bool {
    do {
        let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: key)
        return true
    } catch let error {
        print("Could not create a bookmark because: ", error)
        return false
    }
}

func getPersistentFileURL(_ key: String) -> URL? {
    if let bookmarkData = UserDefaults.standard.data(forKey: "pathSongs") {
         do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            if bookmarkDataIsStale {
                print("The bookmark is outdated and needs to be regenerated.")
                _ = setPersistentFileURL(key, urlForBookmark)
                return nil
 
            } else {
                return urlForBookmark
            }
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } else {
        print("Error retrieving persistent bookmark data.")
        return nil
    }
}

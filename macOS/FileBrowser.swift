//  FileBrowser.swift
//  Chord Provider (macOS)
//
//  A sidebar view with a list of songs from a user selected directory

import SwiftUI

// MARK: Views

struct FileBrowser: View {

    @StateObject var mySongs = MySongs()
    
    var body: some View {
        VStack {
            Button(action: {
                SelectSongsFolder(mySongs)
            } ) {
                Label("My songs", systemImage: "folder").truncationMode(.head).font(.title2)
            }
            .help("The folder with your songs")
            .buttonStyle(PlainButtonStyle())
            List {
                ForEach(mySongs.songList.artists) { artist in
                    Text(artist.name).font(.headline)
                    ForEach(artist.songs) { song in
                        FileBrowserRow(song: song)
                    }
                }
            }
        }
    }
}

struct FileBrowserRow: View {
    let song: ArtistSongs

    var body: some View {
        Button(action: {
            /// Sandbox stuff: get path for selected folder
            if var persistentURL = GetPersistentFileURL("pathSongs") {
                _ = persistentURL.startAccessingSecurityScopedResource()
                persistentURL = persistentURL.appendingPathComponent(song.path, isDirectory: false)
                let configuration = NSWorkspace.OpenConfiguration()
                let bundleIdentifier =  Bundle.main.bundleIdentifier
                guard let chordpro = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier!) else { return }
                NSWorkspace.shared.open([persistentURL],withApplicationAt: chordpro,configuration: configuration)
                persistentURL.stopAccessingSecurityScopedResource()
            }
        } ) {
            Label(song.title, systemImage: (song.musicpath.isEmpty ? "music.note" : "music.note.list"))
        }.buttonStyle(PlainButtonStyle())
    }
}

// MARK: Class and Structs

class MySongs: ObservableObject {
    @Published var songList = GetSongsList()
}

struct ArtistSongs: Identifiable {
    var id = UUID()
    var artist: String = "Unknown artist"
    var title: String = ""
    var path: String = ""
    var musicpath: String = ""
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
        let songs = GetSongsList.GetFiles()
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
    static func GetFiles() -> [ArtistSongs] {
        var songs = [ArtistSongs]()
        /// Get a list of all files
        
        if let persistentURL = GetPersistentFileURL("pathSongs") {
            do {
                /// Sandbox stuff...
                _ = persistentURL.startAccessingSecurityScopedResource()
                let items = try FileManager.default.contentsOfDirectory(atPath: persistentURL.path)
                for item in items {
                    if item.hasSuffix(".pro") {
                        var song = ArtistSongs()
                        ParseSongFile(persistentURL.appendingPathComponent(item, isDirectory: false), item, &song)
                        songs.append(song)
                    }
                }
                persistentURL.stopAccessingSecurityScopedResource()
            } catch {
                /// failed to read directory
                print(error)
            }
        }

        return songs.sorted { $0.title < $1.title }
    }
    /// This is a helper function to parse the song for metadata
    static func ParseSongFile(_ file: URL, _ name: String, _ song: inout ArtistSongs) {
        /// Name is used parsing gives no result
        //song.artist = "Unknown artist"
        song.title = name
        song.path = name
        
        do {
            let data = try String(contentsOf: file, encoding: .utf8)
            
            for text in data.components(separatedBy: .newlines) {
                if (text.starts(with: "{")) {
                    ParseFileLine(text: text, song: &song)
                }
            }
        } catch {
            print(error)
        }
    }
    /// This is a helper function to parse the actual metadata
    static func ParseFileLine(text: String, song: inout ArtistSongs) {
        let attributeRegex = try! NSRegularExpression(pattern: "\\{(\\w*):([^%]*)\\}")
        
        var key: String?
        var value: String?
        if let match = attributeRegex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
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

func SelectSongsFolder(_ mySongs: MySongs) {
    let base = UserDefaults.standard.object(forKey: "pathSongsString") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your songs"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            /// Save the url so next time this dialog is opened it will go to this folder.
            /// Sandbox stuff seems to be ok with that....
            UserDefaults.standard.set(result!.path, forKey: "pathSongsString")
            //UserDefaults.standard.set(result!.path, forKey: "pathSongs")
            /// Create a persistent bookmark for the folder the user just selected
            _ = SetPersistentFileURL("pathSongs", result!)
            /// Refresh the list of songs
            mySongs.songList = GetSongsList()
        }
    }
}

// GetDocumentsDirectory()
// -----------------------
// Returns the users Documents directory.
// Used when no folders are selected by the user.

func GetDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

// Get and Set sandbox bookmarks
// -----------------------------
// Many thanks to https://www.appcoda.com/mac-apps-user-intent/

func SetPersistentFileURL(_ key: String, _ selectedURL: URL) -> Bool {
    do {
        let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: key)
        return true
    } catch let error {
        print("Could not create a bookmark because: ", error)
        return false
    }
}

func GetPersistentFileURL(_ key: String) -> URL? {
    if let bookmarkData = UserDefaults.standard.data(forKey: "pathSongs") {
         do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            if bookmarkDataIsStale {
                print("The bookmark is outdated and needs to be regenerated.")
                _ = SetPersistentFileURL(key, urlForBookmark)
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


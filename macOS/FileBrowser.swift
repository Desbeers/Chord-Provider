//  FileBrowser.swift
//  Chord Provider (macOS)
//
//  A sidebar view with a list of somgs from a user selected directory

import SwiftUI
import os

// MARK: - Views

struct FileBrowser: View {
    /// This is the path to the directory with songs
    /// There is also a 'pathSong' and that one is the sandboxed bookmark version
    @AppStorage("pathSongsString") var pathSongsString:String = GetDocumentsDirectory()
    @StateObject var mySongs = MySongs()
   
    var body: some View {
        VStack {
            Button(action: {
                SelectSongsFolder(mySongs)
            } ) {
                Label("My songs", systemImage: "folder").truncationMode(.head).font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            .help("The folder with your songs")
            List(mySongs.songList) {song in
                Button(action: {
                    /// Sandbox stuff: get path for selected folder
                    if var persistentURL = GetPersistentFileURL() {
                        _ = persistentURL.startAccessingSecurityScopedResource()
                        persistentURL = persistentURL.appendingPathComponent(song.path, isDirectory: false)
                        let configuration = NSWorkspace.OpenConfiguration()
                        let bundleIdentifier =  Bundle.main.bundleIdentifier
                        guard let chordpro = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier!) else { return }
                        NSWorkspace.shared.open([persistentURL],withApplicationAt: chordpro,configuration: configuration)
                        persistentURL.stopAccessingSecurityScopedResource()
                    }
                } ) {
                    VStack(alignment: .leading) {
                        Text(song.artist).font(.headline)
                        Text(song.song).font(.subheadline)
                    }
                }.buttonStyle(PlainButtonStyle())
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}

struct FileBrowser_Previews: PreviewProvider {
    static var previews: some View {
        FileBrowser()
    }
}

// MARK: - classes, structs and functions

class MySongs: ObservableObject {
    var songList = GetSongs()
}

public struct SongList: Hashable, Identifiable {
    public var id = UUID()
    public var path: String
    public var artist: String
    public var song: String
}

// GetSongs()
// -------------------
// Gets nothing
// Returns list of songs

func GetSongs() -> [SongList] {
    os_log("GetSongs: reading folder")
    var songList = [SongList]()
    
    if let persistentURL = GetPersistentFileURL() {
        do {
            /// Sandbox stuff...
            _ = persistentURL.startAccessingSecurityScopedResource()
            let items = try FileManager.default.contentsOfDirectory(atPath: persistentURL.path)
            for item in items {
                if item.hasSuffix(".pro") {
                    let parse = ParseSongName(item)
                    songList.append(SongList(path: item, artist: parse.artist, song: parse.song))
                }
            }
            persistentURL.stopAccessingSecurityScopedResource()
        } catch {
            /// failed to read directory
            print(error)
        }
        /// Sort by author name and then by date.
        songList.sort { $0.artist == $1.artist ? $0.song < $1.song : $0.artist < $1.artist  }
    }
    
    return songList
}


// ParseSongName(filename)
// -------------------
// Gets filename
// Returns artist and song (if any)
//
// For now, the parser doesn't look into the file; that's expensive.
// It looks for  string - string so up to you how to name it.


func ParseSongName(_ name: String) -> (artist: String, song: String) {
    /// Name is used when the regex doesn't work
    var artist:String = name
    var song:String = ""
    
    let songRegex = try! NSRegularExpression(pattern: "(.*)-(.*)\\.", options: .caseInsensitive)
    
    if let match = songRegex.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count)) {
        if let keyRange = Range(match.range(at: 1), in: name) {
            artist = name[keyRange].trimmingCharacters(in: .newlines)
        }

        if let valueRange = Range(match.range(at: 2), in: name) {
            song = name[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    return (artist,song)
}

//  FileBrowser.swift
//  Chord Provider (macOS)
//
//  A sidebar view with a list of somgs from a user selected directory

import SwiftUI

// MARK: - Views

struct FileBrowser: View {
    
    @StateObject var mySongs = MySongs()

    var body: some View {
        VStack {
            Button(action: {
                SelectSongsFolder(mySongs)
                //mySongs.songList = SongsList.GetMySongs()
            } ) {
                Label("My songs", systemImage: "folder").truncationMode(.head).font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            .help("The folder with your songs")
            List {
                ForEach(mySongs.songList.artist) { artist in
                    Text(artist.artist!).font(.headline)
                    ForEach(artist.songs) { songs in
                        //Text(songs.song!).font(.subheadline)
                        Button(action: {
                            /// Sandbox stuff: get path for selected folder
                            if var persistentURL = GetPersistentFileURL() {
                                _ = persistentURL.startAccessingSecurityScopedResource()
                                persistentURL = persistentURL.appendingPathComponent(songs.path!, isDirectory: false)
                                let configuration = NSWorkspace.OpenConfiguration()
                                let bundleIdentifier =  Bundle.main.bundleIdentifier
                                guard let chordpro = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier!) else { return }
                                NSWorkspace.shared.open([persistentURL],withApplicationAt: chordpro,configuration: configuration)
                                persistentURL.stopAccessingSecurityScopedResource()
                            }
                        } ) {
                            Label(songs.song!, systemImage: "music.note")
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
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

// MARK: - classes, structs and functions

class MySongs: ObservableObject {
    @Published var songList = SongsList.GetMySongs()
}

public class MySongsList: Identifiable {
    public var id = UUID()
    public var artist = [MyArtistList]()
}

public class MyArtistList: Identifiable {
    public var id = UUID()
    public var artist: String?
    public var songs = [MyArtistSongsList]()
}

public class MyArtistSongsList: Identifiable {
    public var id = UUID()
    public var song: String?
    public var path: String?
}

public class SongsList {
    // GetMySongs()
    // -------------------
    // Gets nothing
    // Returns list of songs
    static func GetMySongs() -> MySongsList {
        print("Reading folder with songs")
        var songFiles = [String: [[String: String]]]()
        
        if let persistentURL = GetPersistentFileURL() {
            do {
                /// Sandbox stuff...
                _ = persistentURL.startAccessingSecurityScopedResource()
                let items = try FileManager.default.contentsOfDirectory(atPath: persistentURL.path)
                for item in items {
                    if item.hasSuffix(".pro") {
                        let parse = ParseSongName(item)
                        songFiles[parse.artist, default: []].append([parse.song: item])
                    }
                }
                persistentURL.stopAccessingSecurityScopedResource()
            } catch {
                /// failed to read directory
                print(error)
            }
        }
        
        let sortedSongFiles = songFiles.sorted {
            return $0.key < $1.key
        }
        /// Move the dictionary into an array
        let mySongsList = MySongsList()
        for (key, value) in sortedSongFiles {
            
            let myArtistList = MyArtistList()
            mySongsList.artist.append(myArtistList)
            
            myArtistList.artist = key
            
            let sortedSongs = value.sorted( by: { $0.first!.0 < $1.first!.0 })
            
            sortedSongs.forEach { (song) in
                let myArtistSongsList = MyArtistSongsList()
                myArtistList.songs.append(myArtistSongsList)
                myArtistSongsList.song = song.first?.key
                myArtistSongsList.path = song.first?.value
            }
        }
        return mySongsList
    }
    // ParseSongName(filename)
    // -------------------
    // Gets filename
    // Returns artist and song (if any)
    //
    // For now, the parser doesn't look into the file; that's expensive.
    // It looks for  string - string so up to you how to name it.
    static func ParseSongName(_ name: String) -> (artist: String, song: String) {
        /// Name is used when the regex doesn't work
        var artist:String = "Unknown artist"
        var song:String = name
        
        let songRegex = try! NSRegularExpression(pattern: "(.*)-(.*)\\.", options: .caseInsensitive)
        
        if let match = songRegex.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count)) {
            if let keyRange = Range(match.range(at: 1), in: name) {
                artist = name[keyRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }

            if let valueRange = Range(match.range(at: 2), in: name) {
                song = name[valueRange].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return (artist,song)
    }
}



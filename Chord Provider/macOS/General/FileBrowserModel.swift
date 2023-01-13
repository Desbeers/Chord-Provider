//
//  FileBrowserModel.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The observable FileBrowser model
class FileBrowserModel: ObservableObject {
    /// The list of songs
    @Published var songList: [SongItem] = []
    /// The list of artists
    @Published var artistList: [ArtistItem] = []
    /// The list of open windows
    @Published var openWindows: [WindowItem] = []
    /// The MenuBarExtra window
    /// - Note: Needed to close the MenuBarExtra when selecting a song
    var menuBarExtraWindow: NSWindow?
}

extension FileBrowserModel {

    // MARK: Structures

    /// The struct for a song item in the browser
    struct SongItem: Identifiable {
        /// The unique ID
        var id: String {
            path.description
        }
        /// Name of the artist
        var artist: String = "Unknown artist"
        /// Title of the song
        var title: String = ""
        /// The searchable string
        var search: String {
            return "\(title) \(artist)"
        }
        /// Path to the optional audio file
        var musicpath: String = ""
        /// Path to the ChordPro document
        var path: URL
    }

    /// The struct for an artist item in the browser
    struct ArtistItem: Identifiable {
        /// The unique ID
        let id = UUID()
        /// Name of the artist
        let name: String
        /// Songs of the artist
        let songs: [SongItem]
    }

    /// The struct for an open window
    struct WindowItem {
        /// The ID of the `Window`
        let windowID: Int
        /// The URL of the ChordPro document
        let songURL: URL?
    }
}

extension FileBrowserModel {

    // MARK: Functions

    /// Get the song files from the user selected folder
    func getFiles() {
        /// The found songs
        var songs = [SongItem]()
        /// Get a list of all files
        if let persistentURL = FileBrowserModel.getPersistentFileURL("pathSongs") {
            /// Sandbox stuff...
            _ = persistentURL.startAccessingSecurityScopedResource()
            if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if ChordProDocument.fileExtension.contains(item.pathExtension) {
                        var song = SongItem(path: item)
                        parseSongFile(item, &song)
                        songs.append(song)
                    }
                }
            }
            persistentURL.stopAccessingSecurityScopedResource()
        }
        /// Use the Dictionary(grouping:) function so that all the artists are grouped together.
        let grouped = Dictionary(grouping: songs) { (occurrence: SongItem) -> String in
            occurrence.artist
        }
        /// We now map over the dictionary and create our artist objects.
        /// Then we want to sort them so that they are in the correct order.
        artistList = grouped.map { artist -> ArtistItem in
            ArtistItem(name: artist.key, songs: artist.value)
        }.sorted { $0.name < $1.name }
        songList = songs.sorted { $0.title < $1.title }
    }

    /// Parse the song file for metadata
    private func parseSongFile(_ file: URL, _ song: inout SongItem) {
        song.title = file.lastPathComponent

        do {
            let data = try String(contentsOf: file, encoding: .utf8)

            for text in data.components(separatedBy: .newlines) where text.starts(with: "{") {
                parseFileLine(text: text, song: &song)
            }
        } catch {
            print(error)
        }
    }

    /// Parse the actual metadata
    private func parseFileLine(text: String, song: inout SongItem) {
        if let match = text.wholeMatch(of: ChordPro.directiveRegex) {

            let directive = match.1
            let label = match.2

            switch directive {
            case .t, .title:
                song.title = label ?? "Unknown Title"
            case .st, .subtitle, .artist:
                song.artist = label ?? "Unknown Artist"
            case .musicpath:
                if let label {
                    song.musicpath = label
                }
            default:
                break
            }
        }
    }

    /// The folder selector
    func selectSongsFolder(_ fileBrowser: FileBrowserModel) {
        let base = UserDefaults.standard.object(forKey: "pathSongsString") as? String ?? FileBrowserModel.getDocumentsDirectory()
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
                _ = FileBrowserModel.setPersistentFileURL("pathSongs", result!)
                /// Refresh the list of songs
                fileBrowser.getFiles()
            }
        }
    }

    /// Get the Documents directory
    /// - Returns: The users Documents directory
    ///
    /// Used when no folders are selected by the user.
    static func getDocumentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }

    /// Set the sandbox bookmark
    /// - Parameters:
    ///   - key: The name of the bookmark
    ///   - selectedURL: The URL of the bookmark
    /// - Returns: True or false if the bookmark is set
    ///
    /// Many thanks to [https://www.appcoda.com/mac-apps-user-intent/](https://www.appcoda.com/mac-apps-user-intent/)
    static func setPersistentFileURL(_ key: String, _ selectedURL: URL) -> Bool {
        do {
            let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            UserDefaults.standard.set(bookmarkData, forKey: key)
            return true
        } catch let error {
            print("Could not create a bookmark because: ", error)
            return false
        }
    }

    /// Get the sandbox bookmark
    /// - Parameter key: The name of the bookmark
    /// - Returns: The URL of the bookmark
    static func getPersistentFileURL(_ key: String) -> URL? {
        if let bookmarkData = UserDefaults.standard.data(forKey: "pathSongs") {
            do {
                var bookmarkDataIsStale = false
                let urlForBookmark = try URL(
                    resolvingBookmarkData: bookmarkData,
                    options: .withSecurityScope,
                    relativeTo: nil,
                    bookmarkDataIsStale: &bookmarkDataIsStale
                )
                if bookmarkDataIsStale {
                    print("The bookmark is outdated and needs to be regenerated.")
                    _ = FileBrowserModel.setPersistentFileURL(key, urlForBookmark)
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
}

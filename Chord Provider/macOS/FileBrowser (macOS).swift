//
//  FileBrowser.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities

/// The observable FileBrowser for Chord Provider
class FileBrowser: ObservableObject {
    /// The list of songs
    @Published var songList: [SongItem] = []
    /// The list of artists
    @Published var artistList: [ArtistItem] = []
    /// Bool if a folder is selected
    @Published var folder: Bool = true
    /// The name of the folder bookmark
    static let bookmark: String = "SongsFolder"
    /// The list of open windows
    @Published var openWindows: [NSWindow.WindowItem] = []
    /// The MenuBarExtra window
    /// - Note: Needed to close the MenuBarExtra when selecting a song
    var menuBarExtraWindow: NSWindow?
    /// The Class to monitor the songs folder
    let folderMonitor = FolderMonitor()
    /// Init the FileBrowser
    init() {
        folderMonitor.folderDidChange = {
            Task {
                await self.getFiles()
            }
        }
    }
}

extension FileBrowser {

    // MARK: Structures

    /// The struct for a song item in the browser
    struct SongItem: Identifiable {
        /// The unique ID
        var id: String {
            fileURL.description
        }
        /// Name of the artist
        var artist: String = "Unknown artist"
        /// Title of the song
        var title: String = ""
        /// The searchable string
        var search: String {
            return "\(title) \(artist)"
        }
        /// Path of the optional audio file
        var musicPath: String = ""
        /// URL of the ChordPro document
        var fileURL: URL
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
}

extension FileBrowser {

    // MARK: Functions

    /// Get the song files from the user selected folder
    @MainActor
    func getFiles() async {
        do {
            /// The found songs
            var songs = [SongItem]()
            /// Get a list of all files
            try await FolderBookmark.action(bookmark: FileBrowser.bookmark) { persistentURL in
                folderMonitor.addRecursiveURL(persistentURL)
                if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                    while let item = items.nextObject() as? URL {
                        if ChordProDocument.fileExtension.contains(item.pathExtension) {
                            var song = SongItem(fileURL: item)
                            parseSongFile(item, &song)
                            songs.append(song)
                        }
                    }
                }
            }
            /// Use the Dictionary(grouping:) function so that all the artists are grouped together.
            let grouped = Dictionary(grouping: songs) { (occurrence: SongItem) -> String in
                occurrence.artist
            }
            /// We now map over the dictionary and create our artist objects.
            /// Then we want to sort them so that they are in the correct order.
            artistList = grouped.map { artist -> ArtistItem in
                ArtistItem(name: artist.key, songs: artist.value)
            }
            .sorted { $0.name < $1.name }
            songList = songs.sorted { $0.title < $1.title }
            folder = true
        } catch {
            /// There is no folder selected
            folder = false
            print(error.localizedDescription)
        }
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
            case .musicPath:
                if let label {
                    song.musicPath = label
                }
            default:
                break
            }
        }
    }
}

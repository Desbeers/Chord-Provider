//
//  FileBrowser.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities
import OSLog

/// The observable ``FileBrowser`` class
@Observable
class FileBrowser {
    /// The list of songs
    var songList: [SongItem] = []
    /// The list of artists
    var artistList: [ArtistItem] = []
    /// The name of the folder bookmark
    static let folderBookmark: String = "SongsFolder"
    /// The name of the export bookmark
    static let exportBookmark: String = "ExportFolder"
    /// The message of the folder selector
    static let message: String = "Select the folder with your songs"
    /// The label for the confirmation button of the folder selector
    static let confirmationLabel = "Select"
    /// The optional songs folder
    var songsFolder: URL?
    /// The status
    var status: ChordProviderError = .unknownStatus
#if os(macOS)
    /// The list of open windows
    var openWindows: [NSWindow.WindowItem] = []
    /// The MenuBarExtra window
    /// - Note: Needed to close the MenuBarExtra when selecting a song
    var menuBarExtraWindow: NSWindow?
#endif
    /// Init the FileBrowser
    init() {
        songsFolder = FolderBookmark.getBookmarkLink(bookmark: FileBrowser.folderBookmark)
    }
}

extension FileBrowser {

    // MARK: Structures

    /// The struct for a song item in the browser
    struct SongItem: Identifiable, Equatable {
        /// The unique ID
        var id: String {
            fileURL.description
        }
        /// Name of the artist
        var artist: String = "Unknown artist"
        /// Title of the song
        var title: String = ""
        /// The optional tags
        var tags: [String] = []
        /// The searchable string
        var search: String {
            "\(title) \(artist)"
        }
        /// Path of the optional audio file
        var musicPath: String = ""
        /// URL of the ChordPro document
        var fileURL: URL
    }

    /// The struct for an artist item in the browser
    struct ArtistItem: Identifiable {
        /// The unique ID
        var id: String { name }
        /// Name of the artist
        let name: String
        /// Songs of the artist
        let songs: [SongItem]
    }
}

extension FileBrowser {

    // MARK: Functions

    /// Get the song files from the user selected folder
    func getFiles() {
        do {
            var songs = songList
            /// Get a list of all files
            try FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { persistentURL in
                status = .songsFolderIsSelected
                if songs.isEmpty, let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                    while let item = items.nextObject() as? URL {
                        if ChordProDocument.fileExtension.contains(item.pathExtension) {
                            var song = SongItem(fileURL: item)
                            FileBrowser.parseSongFile(item, &song)
                            songs.append(song)
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
            }
        } catch {
            /// There is no folder selected
            songsFolder = nil
            status = .noSongsFolderSelectedError
        }
    }

    /// Parse the song file for metadata
    static func parseSongFile(_ file: URL, _ song: inout SongItem) {

        song.title = file.lastPathComponent

        do {
            let data = try String(contentsOf: file, encoding: .utf8)

            for text in data.components(separatedBy: .newlines) where text.starts(with: "{") {
                parseFileLine(text: text, song: &song)
            }
        } catch {
            Logger.application.error("\(error.localizedDescription, privacy: .public)")
        }

        /// Parse the actual metadata
        func parseFileLine(text: String, song: inout SongItem) {
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
                case .tag:
                    if let label {
                        song.tags.append(label.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                default:
                    break
                }
            }
        }
    }
}

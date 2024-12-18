//
//  FileBrowserModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable file broweser state for **Chord Provider**
@Observable @MainActor class FileBrowserModel {
    /// The shared instance of the class
    static let shared = FileBrowserModel()
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
    var status: AppError = .unknownStatus
    /// The list of open windows
    var openWindows: [NSWindow.WindowItem] = []
    /// Init the FileBrowser
    private init() {
        songsFolder = UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder)
        getFiles()
    }
}

extension FileBrowserModel {

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

extension FileBrowserModel {

    // MARK: Functions

    /// Get the song files from the user selected folder
    func getFiles() {
        var songs = songList
        /// Get a list of all files
        if let songsFolder = UserFileBookmark.getBookmarkURL(UserFileItem.songsFolder) {
            /// Get access to the URL
            _ = songsFolder.startAccessingSecurityScopedResource()
            status = .songsFolderIsSelected
            if
                songs.isEmpty,
                let items = FileManager.default.enumerator(at: songsFolder, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if ChordProDocument.fileExtension.contains(item.pathExtension) {
                        var song = SongItem(fileURL: item)
                        FileBrowserModel.parseSongFile(item, &song)
                        songs.append(song)
                    }
                }
            }
            /// Close access to the URL
            songsFolder.stopAccessingSecurityScopedResource()

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
        } else {
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
            if let match = text.firstMatch(of: RegexDefinitions.directive) {

                let directive = match.1
                let label = match.2

                if let directive = ChordProParser.getDirective(directive.lowercased()) {

                    switch directive.directive {
                    case .title:
                        song.title = label ?? "Unknown Title"
                    case .subtitle, .artist:
                        song.artist = label ?? "Unknown Artist"
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
}

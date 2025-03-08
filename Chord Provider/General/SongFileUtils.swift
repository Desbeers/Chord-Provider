//
//  SongFileUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

enum SongFileUtils {
    // Just a placeholder
}

extension SongFileUtils {

    /// Get all songs from a folder
    /// - Parameters:
    ///   - url: The URL of the folder
    ///   - settings: The ``AppSettings``
    /// - Returns: All songs by title and artists
    static func getSongsFromFolder(url: URL, settings: AppSettings) async -> (songs: [Song], artists: [Artist]) {
        var songs: [Song] = []
        var artists: [Artist] = []
        if let items = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) {
            while let item = items.nextObject() as? URL {
                if ChordProDocument.fileExtension.contains(item.pathExtension), let song = try? await parseSongFile(item, settings: settings) {
                    songs.append(song)
                }
            }
        }
        /// Use the Dictionary(grouping:) function so that all the artists are grouped together.
        let grouped = Dictionary(grouping: songs) { (occurrence: Song) -> String in
            occurrence.metadata.artist
        }
        /// We now map over the dictionary and create our artist objects.
        /// Then we want to sort them so that they are in the correct order.
        artists = grouped.map { artist -> Artist in
            Artist(name: artist.key, sortName: artist.key.removePrefixes(), songs: artist.value)
        }
        .sorted { (lhs: Artist, rhs: Artist) -> Bool in
            lhs.sortName.compare(rhs.sortName, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedAscending
        }
        songs = songs.sorted { (lhs: Song, rhs: Song) -> Bool in
            lhs.metadata.sortTitle.compare(rhs.metadata.sortTitle, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedAscending
        }
        return (songs, artists)
    }

    /// Parse the song file
    /// - Parameters:
    ///   - file: The URL of the file
    ///   - settings: The ``AppSettings``
    /// - Returns: The parsed ``Song``
    static func parseSongFile(_ file: URL, settings: AppSettings) async throws -> Song {
        do {
            let text = try String(contentsOf: file, encoding: .utf8)
            return await ChordProParser.parse(id: UUID(), text: text, transpose: 0, settings: settings, fileURL: file)
        } catch {
            Logger.application.error("\(error.localizedDescription, privacy: .public)")
            throw AppError.noAccessToSongError
        }
    }
}

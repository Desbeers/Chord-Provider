//
//  SongFileUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to deal with a song file
public enum SongFileUtils {
    /// The file extensions Chord Provider can open
    static let chordProExtensions: [String] = ["chordpro", "cho", "crd", "chopro", "chord", "pro"]
}

extension SongFileUtils {

    /// Parse the song file
    /// - Parameters:
    ///   - fileURL: The URL of the file
    ///   - settings: The ``ChordProviderSettings``
    ///   - getOnlyMetadata: Bool to get only metadata of the song
    /// - Returns: The parsed ``Song``
    public static func parseSongFile(
        fileURL: URL,
        settings: ChordProviderSettings,
        getOnlyMetadata: Bool = false
    ) throws -> Song {
        var settings = settings
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let song = Song(id: UUID(), content: content)
            settings.songURL = fileURL
            return ChordProParser.parse(
                song: song,
                settings: settings,
                getOnlyMetadata: getOnlyMetadata
            )
        } catch {
            throw ChordProviderError.fileNotFound
        }
    }
}

extension SongFileUtils {

    /// Get the song content
    /// - Parameters:
    ///   - fileURL: The URL of the file
    /// - Returns: The parsed ``Song``
    public static func getSongContent(
        fileURL: URL
    ) throws -> String {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return content
        } catch {
            throw ChordProviderError.fileNotFound
        }
    }
}

extension SongFileUtils {

    /// Get all songs from a folder
    /// - Parameters:
    ///   - url: The URL of the folder
    ///   - settings: The ``AppSettings``
    ///   - getOnlyMetadata: Bool to get only metadata of the song, defaults to `false`
    /// - Returns: All songs by title and artists
    public static func getSongsFromFolder(
        url: URL,
        settings: ChordProviderSettings,
        getOnlyMetadata: Bool = false
    ) -> (songs: [Song], artists: [Artist]) {
        /// List of articles to ignore when sorting songs and artists
        let sortTokens: [String] = ["the", "a", "de", "een", "’t"]
        var songs: [Song] = []
        var artists: [Artist] = []
        if let items = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) {
            while let item = items.nextObject() as? URL {
                if
                    SongFileUtils.chordProExtensions.contains(item.pathExtension),
                    let song = try? parseSongFile(
                        fileURL: item,
                        settings: settings,
                        getOnlyMetadata: getOnlyMetadata
                    ) {
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
            Artist(name: artist.key, sortName: artist.key.removePrefixes(sortTokens), songs: artist.value)
        }
        .sorted { (lhs: Artist, rhs: Artist) -> Bool in
            lhs.sortName.compare(rhs.sortName, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedAscending
        }
        songs = songs.sorted { (lhs: Song, rhs: Song) -> Bool in
            lhs.metadata.sortTitle.compare(rhs.metadata.sortTitle, options: [.diacriticInsensitive, .caseInsensitive]) == .orderedAscending
        }
        return (songs, artists)
    }
}

extension SongFileUtils {

    /// The structure for an artist
    public struct Artist: Identifiable, Codable {
        /// The unique ID
        public var id: String { name }
        /// Name of the artist
        public let name: String
        /// Sorting name of the artist
        public let sortName: String
        /// Songs of the artist
        public let songs: [Song]
    }
}

//
//  SongFileUtils.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
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
            let song = Song(id: UUID())
            settings.fileURL = fileURL
            return ChordProParser.parse(
                content: content,
                song: song,
                settings: settings,
                getOnlyMetadata: getOnlyMetadata
            )
        } catch {
            throw ChordProviderError.fileNotFound(url: fileURL)
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
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            throw ChordProviderError.fileNotFound(url: fileURL)
        }
    }
}

extension SongFileUtils {

    /// Get all songs from a folder
    /// - Parameters:
    ///   - url: The URL of the folder
    ///   - settings: The core settings
    ///   - getOnlyMetadata: Bool to get only metadata of the song, defaults to `false`
    /// - Returns: All songs by title and artists
    public static func getSongsFromFolder(
        url: URL,
        settings: ChordProviderSettings,
        getOnlyMetadata: Bool = false
    ) -> [Song] {
        var songs: [Song] = []
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
        return songs.sorted { (lhs: Song, rhs: Song) -> Bool in
            lhs.metadata.sortTitle.localizedStandardCompare(rhs.metadata.sortTitle) == .orderedAscending
        }
    }

    /// Group songs by a metadata
    /// - Parameters:
    ///   - songs: The songs to group
    ///   - group: The metadata group
    ///   - sortTokens: The sort tokens for sorting the songs in the group
    ///
    /// - Returns: An array of grouped songs
    public static func groupSongs(
        _ songs: [Song],
        group: Group,
        sortTokens: [String]
    ) -> [SongFileUtils.Grouping] {
        let grouped = Dictionary(grouping: songs) { (occurrence: Song) -> String in
            switch group {
            case .artist:
                return occurrence.metadata.artist
            case .title:
                return String(occurrence.metadata.sortTitle.first?.uppercased() ?? "?")
            case .year:
                return occurrence.metadata.year?.description ?? "Unknown Year"
            case .key:
                return occurrence.metadata.key?.display ?? "Unknown Key"
            case .tempo:
                return "\(occurrence.metadata.tempo?.description ?? "Unknown")"
            }
        }
        // We now map over the dictionary and create our grouped objects.
        // Then we want to sort them so that they are in the correct order.
        let grouping = grouped.map { grouping -> Grouping in
            Grouping(
                group: group,
                name: grouping.key,
                sortString: grouping.key.removePrefixes(sortTokens),
                songs: grouping.value
            )
        }
        if group == .tempo || group == .year {
            // Sort by number
            return grouping.sorted(using: KeyPathComparator(\.sortNumber))
        }
        // Sort by string
        return grouping.sorted(using: KeyPathComparator(\.sortString))
    }
}

extension SongFileUtils {

    /// The structure for grouped songs
    public struct Grouping: Identifiable, Codable {
        /// The unique ID
        public var id: String { name }
        /// The group
        let group: Group
        /// Name of the grouping
        let name: String
        /// Display of the grouping
        public var display: String {
            name + group.suffix
        }
        /// Sorting string of the grouping
        let sortString: String
        /// Sorting number of the grouping
        var sortNumber: Int {
            Int(name) ?? 9999
        }
        /// Songs of the group
        public let songs: [Song]
    }
}

extension SongFileUtils {

    /// The group of song metadata
    public enum Group: String, CaseIterable, Codable {
        case artist
        case title
        case year
        case key
        case tempo
        /// The suffix for the group
        var suffix: String {
            switch self {
            case .tempo:
                " bpm"
            default:
                ""
            }
        }
    }
}

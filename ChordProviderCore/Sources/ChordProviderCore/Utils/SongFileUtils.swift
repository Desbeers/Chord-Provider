//
//  SongFileUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to deal with a song file
public enum SongFileUtils {
    // Just a placeholder
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

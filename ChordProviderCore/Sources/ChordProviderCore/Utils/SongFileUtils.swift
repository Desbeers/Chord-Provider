//
//  SongFileUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// Utilities to deal with a song file
public enum SongFileUtils {
    // Just a placeholder
}

extension SongFileUtils {

    /// Parse the song file
    /// - Parameters:
    ///   - fileURL: The URL of the file
    ///   - instrument: The ``Chord//Instrument``
    ///   - prefixes: Optional prefixes for sorting
    ///   - getOnlyMetadata: Bool to get only metadata of the song
    /// - Returns: The parsed ``Song``
    public static func parseSongFile(
        fileURL: URL,
        instrument: Chord.Instrument,
        prefixes: [String],
        getOnlyMetadata: Bool
    ) async throws -> Song {
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            var song = Song(id: UUID(), content: content)
            song.metadata.fileURL = fileURL
            return await ChordProParser.parse(
                song: song,
                instrument: instrument,
                prefixes: prefixes,
                getOnlyMetadata: getOnlyMetadata
            )
        } catch {
            Logger.parser.error("\(error.localizedDescription, privacy: .public)")
            throw ChordProviderError.fileNotFound
        }
    }
}

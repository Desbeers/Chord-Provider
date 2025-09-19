//
//  ChordProParser+setDefaults.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordProParser {

    /// Set default metadata if not defined in the song file
    /// - Parameter song: The ``Song``
    static func setDefaults(song: inout Song, prefixes: [String]) {
        /// Set the sort title  if not set
        if song.metadata.sortTitle.isEmpty {
            song.metadata.sortTitle = song.metadata.title.removePrefixes(prefixes)
        }
        /// Set the subtitle as artist name if not set
        if song.metadata.artist == "Unknown Artist" {
            song.metadata.artist = song.metadata.subtitle ?? "Unknown Artist"
        }
        /// Set the sort artist name if not set
        if song.metadata.sortArtist.isEmpty {
            song.metadata.sortArtist = song.metadata.artist.removePrefixes(prefixes)
        }
    }
}

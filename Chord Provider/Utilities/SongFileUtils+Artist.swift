//
//  SongFileUtils+Artist.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension SongFileUtils {

    /// The structure for an artist
    struct Artist: Identifiable, Codable {
        /// The unique ID
        var id: String { name }
        /// Name of the artist
        let name: String
        /// Sorting name of the artist
        let sortName: String
        /// Songs of the artist
        let songs: [Song]
    }
}

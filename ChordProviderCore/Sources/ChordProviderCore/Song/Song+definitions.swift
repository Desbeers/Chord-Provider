//
//  Song+definitions.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Song {

    /// Get all the chord definition in the song for the current instrument
    public var definitions: String {
        self.chords.map(\.define).joined(separator: "\n")
    }
}

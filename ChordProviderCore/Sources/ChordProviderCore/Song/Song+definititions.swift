//
//  Song+definititions.swift
//  ChordProviderCore
//
//  Created by Nick Berendsen on 08/01/2026.
//

import Foundation

extension Song {

    /// Get all the chord definition in the song for the current instrument
    public var definitions: String {
        let definitions = self.chords.map(\.define)
        return definitions.map { definition in
            "{define-\(self.settings.instrument.rawValue) \(definition)}"
        }
            .joined(separator: "\n")
    }
}

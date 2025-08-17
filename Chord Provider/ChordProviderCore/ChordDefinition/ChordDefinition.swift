//
//  ChordDefinition.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a chord definition
struct ChordDefinition: Equatable, Codable, Identifiable, Hashable, Sendable {

    // MARK: Database items

    /// The ID of the chord
    var id: UUID
    /// The fret positions of the chord
    var frets: [Int]
    /// The finger positions of the chord
    var fingers: [Int]
    /// The base fret of the chord
    var baseFret: Int
    /// The root of the chord
    var root: Chord.Root
    /// The quality of the chord
    var quality: Chord.Quality

    // MARK: Other items

    /// The name of the chord
    var name: String

    /// The fingers you have to bar for the chord
    /// - Note: A calculated value by the init
    var barres: [Chord.Barre]?

    /// The instrument of the chord
    var instrument: Chord.Instrument

    /// The note of an optional 'slash' chord
    var slash: Chord.Root?
    /// The components of the chord definition
    var components: [Chord.Component] = []
    /// The status of the chord definition
    var status: Status
}

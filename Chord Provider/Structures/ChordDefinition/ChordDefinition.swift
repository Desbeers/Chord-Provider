//
//  ChordDefinition.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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
    var barres: [Chord.Barre]

    /// The instrument of the chord
    var instrument: Instrument

    /// The appended notes on the chord
    var appended: [String] = []
    /// The base note of an optional 'slash' chord
    var bass: Chord.Root?
    /// The components of the chord definition
    var components: [Chord.Component] = []
    /// The status of the chord
    var status: Chord.Status

    // MARK: Coding keys

    /// The coding keys
    /// - Note: Only those items will be in the database
    enum CodingKeys: CodingKey {
        /// The ID of the chord
        case id
        /// The frets of the chord
        case frets
        /// The fingers of the chord
        case fingers
        /// The base fret of the chord
        case baseFret
        /// The root of the chord
        case root
        /// The quality of the chord
        case quality
        /// The optional bass note of the chord
        case bass
    }

    /// Custom encoder for the ``ChordDefinition``
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<ChordDefinition.CodingKeys> = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id, forKey: .id)
        try container.encode(self.frets, forKey: .frets)
        try container.encode(self.fingers, forKey: .fingers)
        try container.encode(self.baseFret, forKey: .baseFret)
        try container.encode(self.root, forKey: .root)
        try container.encode(self.quality, forKey: .quality)
        try container.encode(self.bass, forKey: .bass)
    }
}

//
//  ChordDefinition.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a chord definition
public struct ChordDefinition: Equatable, Codable, Identifiable, Hashable, Sendable, Comparable {
    /// Comparable protocol
    /// - Note: Used for sorting the chords
    public static func < (lhs: ChordDefinition, rhs: ChordDefinition) -> Bool {
        (lhs.display, lhs.status)
        <
        (rhs.display, rhs.status)
    }

    // MARK: Database items

    /// The ID of the chord
    public var id: UUID
    /// The fret positions of the chord
    public var frets: [Int]
    /// The finger positions of the chord
    public var fingers: [Int]
    /// The base fret of the chord
    public var baseFret: Chord.BaseFret
    /// The root of the chord
    public var root: Chord.Root
    /// The quality of the chord
    public var quality: Chord.Quality
    /// The note of an optional 'slash' chord
    public var slash: Chord.Root?

    // MARK: Transposing

    /// The transposed note value
    public var transposed: Int = 0
    /// The transposed name of the chord
    /// - Note: This will be the original name of the chord as defined in the source with the transpose value added
    public var transposedName: String = ""

    // MARK: Other items

    /// Plain text for an unknown or text chord
    public var plain: String = ""
    /// The instrument of the chord
    public var instrument: Chord.Instrument
    /// Bool if the diagram is mirrored
    public var mirrored: Bool = false
    /// The kind of chord definition
    public var kind: Kind
    /// The status of the chord definition
    public var status: Status = .correct

    // MARK: Calculated values by the init()

    /// The fingers you have to bar for the chord
    public var barres: [Chord.Barre]?
    /// The components of the chord definition
    public var components: [Chord.Component] = []
}

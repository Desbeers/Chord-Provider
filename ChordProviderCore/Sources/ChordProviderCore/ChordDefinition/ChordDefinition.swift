//
//  ChordDefinition.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a chord definition
public struct ChordDefinition: Equatable, Codable, Identifiable, Hashable, Sendable {

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

    // MARK: Other items

    /// The name of the chord
    public var name: String

    /// The fingers you have to bar for the chord
    /// - Note: A calculated value by the init
    public var barres: [Chord.Barre]?

    /// The instrument of the chord
    public var instrument: Chord.Instrument
    /// Bool if the diagram is mirrored
    public var mirrored: Bool = false

    /// The note of an optional 'slash' chord
    public var slash: Chord.Root?
    /// The components of the chord definition
    public var components: [Chord.Component] = []
    /// The status of the chord definition
    public var status: Status
}

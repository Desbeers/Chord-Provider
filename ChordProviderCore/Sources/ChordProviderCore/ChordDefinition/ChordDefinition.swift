//
//  ChordDefinition.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

/// The structure of a chord definition
public struct ChordDefinition: Equatable, Codable, Identifiable, Hashable, Sendable, Comparable, CustomStringConvertible {
    
    /// Init the ``ChordDefinition`` with all known values
    /// - Parameters:
    ///   - id: The ID of the ``ChordDefinition``
    ///   - plain: The plain text for an unknown or text chord
    ///   - frets: The fret positions of the ``ChordDefinition``
    ///   - fingers: The finger positions of the ``ChordDefinition``
    ///   - baseFret: The base fret of the ``ChordDefinition``
    ///   - root: The root of the ``ChordDefinition``
    ///   - quality: The quality of the ``ChordDefinition``
    ///   - slash: The bass note of an optional 'slash' chord
    ///   - instrument: The instrument of the ``ChordDefinition``
    ///   - kind: The kind of ``ChordDefinition``
    ///   - status: The status of the ``ChordDefinition``
    public init(
        id: UUID,
        plain: String,
        frets: [Int],
        fingers: [Int],
        baseFret: Chord.BaseFret,
        root: Chord.Root,
        quality: Chord.Quality,
        slash: Chord.Root?,
        instrument: Instrument,
        kind: Kind,
        status: Status
    ) {
        self.id = id
        self.plain = plain
        self.frets = frets
        self.fingers = fingers
        self.baseFret = baseFret
        self.root = root
        self.quality = quality
        self.slash = slash
        self.instrument = instrument
        self.kind = kind
        self.transposedName = "\(plain.isEmpty ? name : plain)-0"
        if status == .unknownStatus {
            // Validate the chord definition
            self.validationWarnings = ChordUtils.Analizer.validateChord(chord: self)
            self.status = Set(validationWarnings ?? []).isDisjoint(with: ChordDefinition.Status.errorStatus)
            ? .correct : .unknownChord(chord: plain)
        }
    }

    /// CustomStringConvertible protocol
    public var description: String {
        define + instrument.tuning.description + status.description + (strum?.description ?? "")
    }

    /// Comparable protocol
    /// - Note: Used for sorting the chords
    public static func < (lhs: ChordDefinition, rhs: ChordDefinition) -> Bool {
        lhs.define < rhs.define
    }

    // MARK: Basic properties

    /// The ID of the ``ChordDefinition``
    public var id = UUID()
    /// The fret positions of the ``ChordDefinition``
    public var frets: [Int]
    /// The finger positions of the ``ChordDefinition``
    public var fingers: [Int]
    /// The base fret of the ``ChordDefinition``
    public var baseFret: Chord.BaseFret
    /// The root of the ``ChordDefinition``
    public var root: Chord.Root
    /// The quality of the ``ChordDefinition``
    public var quality: Chord.Quality
    /// The bass note of an optional 'slash' chord
    public var slash: Chord.Root?
    /// The capo value of the ``ChordDefinition``
    public var capo: Int = 0

    // MARK: Transposing

    /// The transposed note value
    public var transposed: Int = 0
    /// The transposed name of the chord
    /// - Note: This will be the original name of the chord as defined in the source with the transpose value added
    var transposedName: String = ""

    // MARK: Validation

    /// The kind of ``ChordDefinition``
    public var kind: Kind
    /// The validation warnings
    /// - Note: Should be nil for a correct ``ChordDefinition``
    internal(set) public var validationWarnings: [Status]?
    /// The status of the ``ChordDefinition``
    public var status: Status = .unknownStatus

    // MARK: Strum

    /// The optional strumming of the ``ChordDefinition``
    public var strum: Chord.Strum?

    // MARK: Other items

    /// The plain text for an unknown or text chord
    public var plain: String
    /// The instrument of the ``ChordDefinition``
    public var instrument: Instrument = Instrument[.guitar]
}

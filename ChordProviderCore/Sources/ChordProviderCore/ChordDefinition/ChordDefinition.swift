//
//  ChordDefinition.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// The structure of a chord definition
public struct ChordDefinition: Equatable, Codable, Identifiable, Hashable, Sendable, Comparable, CustomStringConvertible {

        // MARK: Init with all known values

    /// Init the ``ChordDefinition`` with all known values
    public init(
        id: UUID,
        plain: String = "",
        frets: [Int],
        fingers: [Int],
        baseFret: Chord.BaseFret,
        root: Chord.Root,
        quality: Chord.Quality,
        slash: Chord.Root?,
        instrument: Instrument,
        kind: Kind,
        status: Status = .unknownStatus
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
        self.transposedName =  (self.plain.isEmpty ? self.name : self.plain) + "-0"
        if status == .unknownStatus {
            /// Validate the chord definition
            self.validationWarnings = self.validate
        } else {
            self.validationWarnings = [status]
        }
    }

    /// CustomStringConvertible protocol
    public var description: String {
        define + instrument.tuning.description + status.description
    }

    /// Comparable protocol
    /// - Note: Used for sorting the chords
    public static func < (lhs: ChordDefinition, rhs: ChordDefinition) -> Bool {
        (lhs.root, lhs.quality.rawValue, lhs.slash ?? .all, lhs.baseFret)
        <
        (rhs.root, rhs.quality.rawValue, rhs.slash ?? .all, rhs.baseFret)
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

    // MARK: Validation

    /// The kind of chord definition
    public var kind: Kind
    /// The validation warnings
    /// - Note: Should be empty for a correct chord definition
    public var validationWarnings: [Status] = []
    /// The status of the chord definition
    public var status: Status {
        Set(validationWarnings).isDisjoint(with: ChordDefinition.Status.errorStatus) ? .correct : .unknownChord
    }

    // MARK: Other items

    /// Plain text for an unknown or text chord
    public var plain: String
    /// The instrument of the chord
    public var instrument: Instrument
    /// Bool if the diagram is mirrored
    public var mirrored: Bool = false

    // MARK: Calculated values

    /// Bool if the chord is considered 'known' and can have a diagram
    public var knownChord: Bool {
        switch self.kind {
        case .standardChord, .transposedChord, .customChord:
            self.status == .correct ? true : false
        default:
            false
        }
    }

    /// The fingers you have to bar for the chord
    public var barres: [Chord.Barre]? {
        ChordUtils.fingersToBarres(
            frets: frets,
            fingers: fingers
        )
    }
    /// The components of the chord definition
    public var components: [Chord.Component] {
        ChordUtils.fretsToComponents(
            root: root,
            frets: frets,
            baseFret: baseFret,
            instrument: instrument
        )
    }
}

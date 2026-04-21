//
//  ChordDefinition+define.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// Create a ``ChordDefinition`` structure from a **ChordPro** *{define}* directive
    ///
    /// *{define}* example:
    /// ```swift
    /// {define G base-fret 1 frets 3 2 0 0 0 3 fingers 2 1 0 0 0 3}
    /// ```
    /// For more information about the *{define}* directive,
    /// see [Directives: define](https://www.chordpro.org/chordpro/directives-define/)
    ///
    /// - Parameter define: ChordPro string definition of the chord
    /// - Parameter instrument: The ``Chord/Instrument`` to use
    /// - Throws: An ``ChordDefinition/Status/unknownChord`` error when the string cannot be parsed
    /// - Returns: A  ``ChordDefinition`` structure
    static func define(from define: String, instrument: Instrument) throws(ChordDefinition.Status) -> ChordDefinition {
        if let definition = define.firstMatch(of: RegexDefinitions.chordDefine) {
            var frets: [Int] = []
            var fingers: [Int] = []
            /// Find the chord elements
            let elements = ChordUtils.Analizer.findChordElements(chord: definition.1)
            guard
                /// Make sure we have a root and a quality
                let root = elements.root,
                let quality = elements.quality
            else {
                throw .unknownChord(chord: definition.1)
            }
            guard
                /// Make sure we have a base fret
                let rawValue = definition.2,
                let baseFret = Chord.BaseFret(rawValue: rawValue)
            else {
                throw .noBaseFret
            }
            if let fretsDefinition = definition.3 {
                frets = fretsDefinition.components(separatedBy: .whitespacesAndNewlines).compactMap { Int($0) }
            } else {
                throw .noFrets
            }
            if let fingersDefinition = definition.4 {
                fingers = fingersDefinition.components(separatedBy: .whitespacesAndNewlines).compactMap { Int($0) }
            }
            /// Fill the fingers if none are set because fingers are optional
            if fingers.isEmpty {
                fingers = Array(repeating: 0, count: instrument.strings.count)
            }
            let chordDefinition = ChordDefinition(
                id: UUID(),
                frets: frets,
                fingers: fingers,
                baseFret: baseFret,
                root: root,
                quality: quality,
                slash: elements.slash,
                instrument: instrument,
                kind: .customChord,
                status: .unknownStatus
            )
            return chordDefinition
        }
        throw .unknownChord(chord: "?")
    }

    /// Create a ``ChordDefinition`` structure from a **ChordPro** JSON chord
    ///
    /// *JSON* example:
    /// ```json
    /// {
    ///     "base" : 1,
    ///     "fingers" : [0, 0, 1, 2, 3, 0],
    ///     "frets" : [-1, 0, 2, 2, 2, 0],
    ///     "name" : "A"
    /// }
    ///  ```
    ///
    /// - Parameters:
    ///   - chord: A **ChordPro** JSON chord
    ///   - instrument: The ``Chord/Instrument`` to use
    /// - Throws: An error when the root and quality is not found
    /// - Returns: A  ``ChordDefinition`` structure
    ///
    /// - Note: The chords in the  **Chord Provider** database are in the same
    ///   JSON format as used in the official **ChordPro** implementation.
    static func define(from chord: ChordPro.Instrument.Chord, instrument: Instrument) throws(ChordDefinition.Status) -> ChordDefinition {
        let elements = ChordUtils.Analizer.findChordElements(chord: chord.name)
        guard
            let root = elements.root,
            let quality = elements.quality
        else {
            throw ChordDefinition.Status.unknownChord(chord: chord.name)
        }
        /// Throw an error if the defined frets does not match the instrument
        let positions = instrument.strings.count
        if chord.frets?.count ?? 0 < positions {
            throw ChordDefinition.Status.notEnoughFrets
        }
        if chord.frets?.count ?? 0 > positions {
            throw ChordDefinition.Status.tooManyFrets
        }

        /// Fill the fingers if not set (complete)
        var fingers = chord.fingers ?? []
        while fingers.count < instrument.strings.count { fingers.append(0) }
        let chordDefinition = ChordDefinition(
            id: UUID(),
            frets: chord.frets ?? [],
            fingers: fingers,
            baseFret: Chord.BaseFret(rawValue: chord.base ?? 1) ?? .one,
            root: root,
            quality: quality,
            slash: elements.slash,
            instrument: instrument,
            kind: .standardChord,
            status: .unknownStatus
        )
        return chordDefinition
    }
}

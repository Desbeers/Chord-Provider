//
//  ChordDefinition+define.swift
//  Chord Provider
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
    /// For more information about the *{define}* directive, see [Directives: define](https://www.chordpro.org/chordpro/directives-define/)
    ///
    /// - Parameter define: ChordPro string definition of the chord
    /// - Parameter instrument: The ``Chord/Instrument`` to use
    /// - Throws: An ``ChordDefinition/Status/unknownChord`` error when the string cannot be parsed
    /// - Returns: A  ``ChordDefinition`` structure
    static func define(from define: String, instrument: Chord.Instrument) throws -> ChordDefinition {
        if let definition = define.firstMatch(of: Chord.RegexDefinitions.chordDefine) {

            let positions = instrument.strings.count

            var frets: [Int] = []
            var fingers: [Int] = []

            let elements = ChordUtils.Analizer.findChordElements(chord: definition.1)
            guard
                let root = elements.root,
                let quality = elements.quality
            else {
                throw ChordDefinition.Status.unknownChord
            }

            if let fretsDefinition = definition.3 {
                frets = fretsDefinition.components(separatedBy: .whitespacesAndNewlines).map { Int($0) ?? -1 }
            }

            if let fingersDefinition = definition.4 {
                fingers = fingersDefinition.components(separatedBy: .whitespacesAndNewlines).map { Int($0) ?? 0 }
            }
            /// Fill the fingers if not set (complete)
            while fingers.count < instrument.strings.count { fingers.append(0) }
            /// Throw an error if the defined frets does not mach the instrument
            if frets.count < positions {
                throw ChordDefinition.Status.notEnoughFrets
            }
            if frets.count > positions {
                throw ChordDefinition.Status.toManyFrets
            }

            let chordDefinition = ChordDefinition(
                id: UUID(),
                name: definition.1,
                frets: frets,
                fingers: fingers,
                baseFret: definition.2 ?? 1,
                root: root,
                quality: quality,
                slash: elements.slash,
                instrument: instrument
            )
            return chordDefinition
        }
        throw ChordDefinition.Status.unknownChord
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
    ///   -  chord: A **ChordPro** JSON chord
    ///   - instrument: The ``Chord/Instrument`` to use
    /// - Throws: An ``ChordDefinition/Status/chordIsCopy`` error when the chord is a copy of another chord
    /// - Returns: A  ``ChordDefinition`` structure
    ///
    /// - Note: The chords in the  **Chord Provider** database are in the same JSON format as used in the official **ChordPro** implementation.
    static func define(from chord: ChordPro.Instrument.Chord, instrument: Chord.Instrument) throws -> ChordDefinition {
        if chord.copy == nil {
            let elements = ChordUtils.Analizer.findChordElements(chord: chord.name)
            guard
                let root = elements.root,
                let quality = elements.quality
            else {
                throw ChordDefinition.Status.unknownChord
            }
            let chordDefinition = ChordDefinition(
                id: UUID(),
                name: chord.name,
                frets: chord.frets ?? [],
                fingers: chord.fingers ?? [],
                baseFret: chord.base ?? 1,
                root: root,
                quality: quality,
                slash: elements.slash,
                instrument: instrument
            )
            return chordDefinition
        } else {
            throw ChordDefinition.Status.chordIsCopy
        }
    }
}

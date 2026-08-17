//
//  ChordDefinition+define.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension ChordDefinition {

    /// Init a Chord Definition structure from a **ChordPro** *{define}* directive
    ///
    /// *{define}* example:
    /// ```swift
    /// {define G base-fret 1 frets 3 2 0 0 0 3 fingers 2 1 0 0 0 3}
    /// ```
    /// For more information about the *{define}* directive,
    /// see [Directives: define](https://www.chordpro.org/chordpro/directives-define/)
    ///
    /// - Parameter define: The **ChordPro** definition of the chord
    /// - Parameter instrument: The ``Instrument`` for this definition
    ///
    /// - Throws: An ``ChordDefinition/Status/unknownChord(chord:)`` error when the string cannot be parsed
    public init(
        define: String,
        instrument: Instrument,
    ) throws(ChordDefinition.Status) {
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
                frets = fretsDefinition
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                    .map { Int($0) ?? -1 }
            } else {
                throw .noFrets
            }
            if let fingersDefinition = definition.4 {
                fingers = fingersDefinition
                    .components(separatedBy: .whitespacesAndNewlines)
                    .filter { !$0.isEmpty }
                    .map { Int($0) ?? 0 }
            }
            /// Fill the fingers if none are set because fingers are optional
            if fingers.isEmpty {
                fingers = Array(repeating: 0, count: instrument.strings.count)
            }
            self = ChordDefinition(
                id: UUID(),
                plain: "",
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
        } else {
            throw .unknownChord(chord: "?")
        }
    }

    /// Init a Chord Definition structure from a **ChordPro** JSON chord
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
    ///   - chord: A **ChordPro** JSON chord definition
    ///   - instrument: The ``Instrument`` for this definition
    ///
    /// - Throws: An error when the root and quality is not found
    ///
    /// - Note: The chords in the  **Chord Provider** database are in the same
    ///   JSON format as used in the official **ChordPro** implementation.
    public init(chord: ChordPro.Instrument.Chord, instrument: Instrument) throws(ChordDefinition.Status) {
        let elements = ChordUtils.Analizer.findChordElements(chord: chord.name)
        guard
            let root = elements.root,
            let quality = elements.quality
        else {
            throw ChordDefinition.Status.unknownChord(chord: chord.name)
        }
        /// The amount of strings for the instrument 
        let instrumentStrings = instrument.strings.count
        // Throw an error if the defined frets does not match the instrument
        if chord.frets?.count ?? 0 < instrumentStrings {
            throw ChordDefinition.Status.notEnoughFrets
        }
        if chord.frets?.count ?? 0 > instrumentStrings {
            throw ChordDefinition.Status.tooManyFrets
        }

        /// Fill the fingers if not set (complete)
        var fingers = chord.fingers ?? []
        while fingers.count < instrument.strings.count {
            fingers.append(0)
        }
        self = ChordDefinition(
            id: UUID(),
            plain: "",
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
    }
}

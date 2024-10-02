//
//  Utils+Define.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Utils {

    /// Create a `ChordDefinition` struct from a string which defines a Chord with a ChordPro *define* directive
    ///
    ///  For more information about the layout, have a look at https://www.chordpro.org/chordpro/directives-define/
    ///
    /// - Parameter define: ChordPro string definition of the chord
    /// - Returns: A  ``ChordDefinition`` struct, if found, else an Error
    static func define(from define: String, instrument: Instrument) throws -> ChordDefinition {
        if let definition = define.firstMatch(of: RegexDefinitions.chordDefine) {

            let positions = instrument.strings.count

            var frets: [Int] = []
            var fingers: [Int] = []

            let elements = Analizer.findChordElements(chord: definition.1)
            guard
                let root = elements.root,
                let quality = elements.quality
            else {
                throw Chord.Status.unknownChord
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
                throw Chord.Status.notEnoughFrets
            }
            if frets.count > positions {
                throw Chord.Status.toManyFrets
            }

            let chordDefinition = ChordDefinition(
                id: UUID(),
                name: definition.1,
                frets: frets,
                fingers: fingers,
                baseFret: definition.2 ?? 1,
                root: root,
                quality: quality,
                bass: elements.bass,
                instrument: instrument
            )
            return chordDefinition
        }
        throw Chord.Status.unknownChord
    }
}

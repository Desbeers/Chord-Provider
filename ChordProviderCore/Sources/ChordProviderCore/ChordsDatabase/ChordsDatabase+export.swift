//
//  ChordsDatabase+export.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Export function for the chords database
extension ChordsDatabase {

    /// Export the definitions to a JSON string
    /// - Parameters:
    ///   - database: The chords databse
    /// - Returns: A JSON string with chord definitions in **ChordPro** format
    public func exportToJSON() throws -> String {
        let basicAndSharps = self.definitions.filter { $0.root.accidental != .flat }
        var chords = basicAndSharps.map { chord in
            ChordPro.Instrument.Chord(
                name: chord.name,
                display: chord.name == chord.display ? nil : chord.display,
                base: chord.baseFret.rawValue,
                frets: chord.frets,
                fingers: chord.fingers
            )
        }
        let flats = self.definitions.filter { $0.root.accidental == .sharp }
        chords += flats.map { chord in
            /// Make an editable copy
            var copy = chord
            /// Swap sharp for flat
            copy.root = chord.root.swapSharpForFlat
            return ChordPro.Instrument.Chord(
                name: copy.name,
                display: copy.name == copy.display ? nil : copy.display,
                base: copy.baseFret.rawValue,
                frets: copy.frets,
                fingers: copy.fingers
            )
        }
        chords.sort(
            using: [
                KeyPathComparator(\.name),
                KeyPathComparator(\.base),
                KeyPathComparator(\.frets?.description)
            ]
        )
        let export = ChordPro.Instrument(
            instrument: .init(
                description: self.instrument.label,
                type: self.instrument.kind.rawValue
            ),
            tuning: self.instrument.tuning.map { "\($0.note)\($0.octave)" },
            chords: chords
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        do {
            let encodedData = try encoder.encode(export)
            return String(data: encodedData, encoding: .utf8) ?? "error"
        } catch {
            throw ChordProviderError.noChordsDefined
        }
    }
}

//
//  Chords.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to get ``ChordDefinition`` arrays
enum Chords {
    // Just a placeholder
}

extension Chords {

    /// Get all the guitar chords in a ``ChordDefinition`` array
    static let guitar = Chords.importInstrument(.guitar)

    /// Get all the guitalele chords in a ``ChordDefinition`` array
    static let guitalele = Chords.importInstrument(.guitalele)

    /// Get all the ukulele chords in a ``ChordDefinition`` array
    static let ukulele = Chords.importInstrument(.ukulele)

    /// Get all chord definitions for an instrument
    /// - Parameter instrument: The ``Instrument``
    /// - Returns: An ``ChordDefinition`` array
    static func getAllChordsForInstrument(instrument: Instrument) -> [ChordDefinition] {
        switch instrument {
        case .guitar:
            Chords.guitar
        case .guitalele:
            Chords.guitalele
        case .ukulele:
            Chords.ukulele
        }
    }

    /// Import a definition database from a JSON database file
    private static func importInstrument( _ instrument: Instrument) -> [ChordDefinition] {
        let database = Bundle.main.decode(ChordPro.Instrument.self, from: instrument.database)
        return importDatabase(database: database, instrument: instrument)
    }

    /// Import a database with chord definitions
    /// - Parameter database: The ``ChordPro/Instrument`` to import
    /// - Parameter instrument: The ``Instrument`` to use
    /// - Returns: An array of ``ChordDefinition``
    static func importDatabase(database: ChordPro.Instrument, instrument: Instrument) -> [ChordDefinition] {
        var definitions: [ChordDefinition] = []
        /// Get all chord definitions
        for chord in database.chords where chord.copy == nil {
            if let result = ChordDefinition(chord: chord, instrument: instrument) {
                definitions.append(result)
            }
        }
        /// Get all copies of chord definitions
        for chord in database.chords where chord.copy != nil {
            if var copy = definitions.first(where: { $0.name == chord.copy }) {
                copy.name = chord.name
                copy.root = copy.root.swapSharpForFlat
                copy.id = UUID()
                definitions.append(copy)
            }
        }
        return definitions.sorted(
            using: [
                KeyPathComparator(\.baseFret), KeyPathComparator(\.frets.description)
            ]
        )
    }

    /// Export the definitions to a JSON string
    /// - Parameters:
    ///   - definitions: The chord definitions
    ///   - uniqueNames: Bool if the chord name should be unique, so one chord for each name
    /// - Returns: A JSON string with chord definitions in **ChordPro** format
    static func exportToJSON(definitions: [ChordDefinition], uniqueNames: Bool) throws -> String {
        guard
            /// The first definition is needed to find the instrument
            let instrument = definitions.first?.instrument
        else {
            throw Chord.Status.noChordsDefined
        }
        let basicAndSharps = definitions.filter { $0.root.accidental != .flat }
        var chords = basicAndSharps.map { chord in
            ChordPro.Instrument.Chord(
                name: chord.name,
                display: chord.name == chord.display ? nil : chord.display,
                base: chord.baseFret,
                frets: chord.frets,
                fingers: chord.fingers,
                copy: nil
            )
        }
        let flats = definitions.filter { $0.root.accidental == .sharp }
        chords += flats.map { chord in
            /// Make an editable copy
            var copy = chord
            /// Swap sharp for flat
            copy.root = chord.root.swapSharpForFlat
            /// Change the name
            copy.name = "\(copy.root.rawValue)\(chord.quality.rawValue)"
            if let slash = chord.slash {
                copy.name += "/\(slash.rawValue)"
            }
            return ChordPro.Instrument.Chord(
                name: copy.name,
                display: copy.name == copy.display ? nil : copy.display,
                base: copy.baseFret,
                frets: copy.frets,
                fingers: copy.fingers,
                copy: nil
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
                description: instrument.description,
                type: instrument.rawValue
            ),
            tuning: instrument.tuning,
            chords: uniqueNames ? chords.uniqued(by: \.name) : chords,
            pdf: .init(diagrams: .init(vcells: 6))
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let encodedData = try encoder.encode(export)
            return String(data: encodedData, encoding: .utf8) ?? "error"
        } catch {
            throw Chord.Status.noChordsDefined
        }
    }
}

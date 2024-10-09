//
//  Chords.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// Bits and pieces to get chord definitions
enum Chords {
    // Just a placeholder
}

extension Chords {

    // MARK: Public

    /// Get all the guitar chords in a ``ChordDefinition`` array
    static let guitar = Chords.importInstrument(.guitar)

    /// Get all the guitalele chords in a ``ChordDefinition`` array
    static let guitalele = Chords.importInstrument(.guitalele)

    /// Get all the ukulele chords in a ``ChordDefinition`` array
    static let ukulele = Chords.importInstrument(.ukulele)

    /// Export a ``ChordDefinition`` array to JSON format
    /// - Parameter definitions: A ``ChordDefinition`` array
    /// - Returns: The ``Database`` in JSON format
    static func exportInstrument(definitions: [ChordDefinition]) throws -> String {
        do {
            return try exportToJSON(definitions: definitions)
        } catch {
            throw Chord.Status.noChordsDefined
        }
    }

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

    // MARK: Private

    /// Import a definition database from a JSON database file
    private static func importInstrument( _ instrument: Instrument) -> [ChordDefinition] {
        let database = Bundle.main.decode(ChordPro.Instrument.self, from: instrument.database)
        return importDatabase(database: database, instrument: instrument)
    }

    /// Import a database with chord definitions
    /// - Parameter database: The ``Database`` to import
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
                copy.root = copy.root.swapSharpFlat
                copy.id = UUID()
                definitions.append(copy)
            }
        }
        return definitions.sorted(using: KeyPathComparator(\.baseFret))
    }

    /// Export the definitions to a JSON string
    /// - Parameter definitions: The chord definitions
    /// - Returns: A String will all definitions
    static func exportToJSON(definitions: [ChordDefinition]) throws -> String {
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
            copy.root = chord.root.swapSharpFlat
            /// Change the name
            copy.name = "\(copy.root.rawValue)\(chord.quality.rawValue)"
            if let bass = chord.bass {
                copy.name += "/\(bass.rawValue)"
            }
            return ChordPro.Instrument.Chord(
                name: copy.name,
                display: copy.name == copy.display ? nil : copy.display,
                base: nil,
                frets: nil,
                fingers: nil,
                /// Make it a copy of the sharp chord
                copy: chord.name
            )
        }

        chords.sort(using: KeyPathComparator(\.base))

        let export = ChordPro.Instrument(
            instrument: .init(
                description: instrument.description,
                type: instrument.rawValue
            ),
            tuning: instrument.tuning,
            chords: chords.reversed(),
            pdf: .init(diagrams: .init(vcells: 6))
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(export)
            return String(decoding: encodedData, as: UTF8.self)
        } catch {
            throw Chord.Status.noChordsDefined
        }
    }
}

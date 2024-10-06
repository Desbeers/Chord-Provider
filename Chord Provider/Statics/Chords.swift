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
    static func exportInstrument(definitions: [ChordDefinition]) -> String {
        exportDefinitions(definitions: definitions)
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
        return importDatabase(database: database)
    }

    /// Export the definitions to a JSON string
    /// - Parameter definitions: The chord definitions
    /// - Returns: A String will all definitions
    static func exportToJSON(definitions: [ChordDefinition]) throws -> String {
        return ""
//        guard
//            /// The first definition is needed to find the instrument
//            let instrument = definitions.first?.instrument
//        else {
//            throw Chord.Status.noChordsDefined
//        }
//        /// Only export basic and sharp chords first; flat chords are treated as a copy
//        let basicAndSharps = definitions.filter { $0.root.accidental != .flat }
//        var chords = definitions.map { chord in
//            
//            let name = chord.root.accidental == .flat ? chord.root.copy : chord.root
//            let copy = chord.root.accidental == .flat ? chord.root : nil
//
//            name += chord.quality.display
//            if let bass = self.bass {
//                name += "/\(bass.display)"
//            }
//
//            ChordPro.Instrument.Chord(
//                name: chord.name,
//                display: chord.name == chord.displayName ? nil : chord.displayName,
//                base:  chord.root.accidental == .flat ? nil : chord.baseFret,
//                frets: chord.root.accidental == .flat ? nil : chord.frets,
//                fingers: chord.root.accidental == .flat ? nil : chord.fingers,
//                copy: chord.root.accidental == .flat ? nil : nil
//            )
//        }
//
//        let export = ChordPro.Instrument(
//            instrument: .init(
//                description: instrument.description,
//                type: instrument.rawValue
//            ),
//            tuning: instrument.tuning,
//            chords: chords,
//            pdf: .init(diagrams: .init(vcells: 6))
//        )
//
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let encodedData = try encoder.encode(export)
//            return String(decoding: encodedData, as: UTF8.self)
//        } catch {
//            return "error"
//        }
//
//
//
//        let definitions = definitions.map(\.define).sorted()
//
//        let export = ChordsDatabase(
//            instrument: firstDefinition.instrument,
//            definitions: definitions
//        )
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        do {
//            let encodedData = try encoder.encode(export)
//            return String(decoding: encodedData, as: UTF8.self)
//        } catch {
//            throw Chord.Status.noChordsDefined
//        }
    }

    /// Import a database with chord definitions
    /// - Parameter database: The ``Database`` to import
    /// - Returns: An array of ``ChordDefinition``
    static func importDatabase(database: ChordPro.Instrument) -> [ChordDefinition] {
        var definitions: [ChordDefinition] = []
        if let instrument = Instrument(rawValue: database.instrument.type) {
            /// Get all chord definitions
            for chord in database.chords where chord.copy == nil {
                if let result = ChordDefinition(chord: chord, instrument: instrument) {
                    definitions.append(result)
                }
            }
            /// Get all copies of chord definitions
            for chord in database.chords where chord.copy != nil {
                if var copy = definitions.first(where: { $0.name == chord.copy }) {
                    dump(copy)
                    copy.name = chord.name
                    copy.root = copy.root.copy
                    definitions.append(copy)
                }
            }
        }
        return definitions.sorted(using: KeyPathComparator(\.baseFret))
    }
}

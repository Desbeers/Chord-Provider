//
//  Chords.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

/// Bits and pieces to get chord definitions
public enum Chords {
    // Just a placeholder
}

extension Chords {

    // MARK: Public

    /// Get all the guitar chords in a ``ChordDefinition`` array
    public static let guitar = Chords.importDefinitions(instrument: .guitarStandardETuning)

    /// Get all the guitalele chords in a ``ChordDefinition`` array
    public static let guitalele = Chords.importDefinitions(instrument: .guitaleleStandardATuning)

    /// Get all the ukulele chords in a ``ChordDefinition`` array
    public static let ukulele = Chords.importDefinitions(instrument: .ukuleleStandardGTuning)

    /// Get all the database definitions in JSON format
    /// - Parameter instrument: The ``Instrument``
    /// - Returns: The ``Database`` in JSON format
    public static func jsonDatabase(instrument: Instrument) -> String {
        Bundle.main.json(from: instrument.database)
    }

    /// Import a ``Database`` in JSON format to a ``ChordDefinition`` array
    /// - Parameter database: The ``Database`` in JSON format
    /// - Returns: A ``ChordDefinition`` array
    public static func importDatabase(database: String) -> [ChordDefinition] {
        importDefinitions(database: database)
    }

    /// Export a ``ChordDefinition`` array to a ``Database`` in JSON format
    /// - Parameter definitions: A ``ChordDefinition`` array
    /// - Returns: The ``Database`` in JSON format
    public static func exportDatabase(definitions: [ChordDefinition]) -> String {
        exportDefinitions(definitions: definitions)
    }

    /// Get all chord definitions for an instrument
    /// - Parameter instrument: The ``Instrument``
    /// - Returns: An ``ChordDefinition`` array
    public static func getAllChordsForInstrument(instrument: Instrument) -> [ChordDefinition] {
        switch instrument {
        case .guitarStandardETuning:
            Chords.guitar
        case .guitaleleStandardATuning:
            Chords.guitalele
        case .ukuleleStandardGTuning:
            Chords.ukulele
        }
    }

    // MARK: Private

    /// Import a definition database from a JSON database file
    /// - Parameter database: The ``Instrument``
    /// - Returns: An array of ``ChordDefinition``
    static func importDefinitions(instrument: Instrument) -> [ChordDefinition] {
        let database = Bundle.main.decode(Database.self, from: instrument.database)
        return importDatabase(database: database)
    }

    /// Import a definition database from a JSON string
    /// - Parameter database: The database in JSON format
    /// - Returns: An array of ``ChordDefinition``
    static func importDefinitions(database: String) -> [ChordDefinition] {
        let decoder = JSONDecoder()
        guard let data = database.data(using: .utf8)
        else { return [] }

        do {
            let database = try decoder.decode(Database.self, from: data)
            return importDatabase(database: database)
        } catch {
            print(error)
            return []
        }
    }

    /// Export the definitions to a String
    /// - Parameter definitions: The chord definitions
    /// - Returns: A String will all definitions
    static func exportDefinitions(definitions: [ChordDefinition]) -> String {
        guard
            /// The first definition is needed to find the instrument
            let firstDefinition = definitions.first
        else {
            return("No definitions")
        }
        let definitions = definitions.map(\.define).sorted()

        let export = Database(
            instrument: firstDefinition.instrument,
            definitions: definitions
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(export)
            return String(decoding: encodedData, as: UTF8.self)
        } catch {
            return "error"
        }
    }

    /// Import a database with chord definitions
    /// - Parameter database: The ``Database`` to import
    /// - Returns: An array of ``ChordDefinition``
    static func importDatabase(database: Database) -> [ChordDefinition] {
        var definitions: [ChordDefinition] = []
        for definition in database.definitions {
            if let result = try? ChordDefinition(
                definition: definition,
                instrument: database.instrument,
                status: .standardChord
            ) {
                definitions.append(result)
            }
        }
        return definitions.sorted(using: KeyPathComparator(\.baseFret))
    }

    /// Parse a String with chord definitions
    /// - Parameters:
    ///   - instrument: The ``Instrument``
    ///   - definitions: The definitions as String
    /// - Returns: An array of ``ChordDefinition``
    static func parseDefinitions(instrument: Instrument, definitions: String) -> [ChordDefinition] {
        definitions.split(separator: "\n", omittingEmptySubsequences: true).map { definition in
            if let result = try? ChordDefinition(
                definition: String(definition),
                instrument: instrument,
                status: .standardChord
            ) {
                return result
            }
            return ChordDefinition(unknown: "Unknown", instrument: instrument)
        }
    }
}

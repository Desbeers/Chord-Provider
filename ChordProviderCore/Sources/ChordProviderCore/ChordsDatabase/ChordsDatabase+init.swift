//
//  ChordsDatabase+init.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Additional init's for a Chord Database
extension ChordsDatabase {

    /// Init an empty Chords Database, defaults to guitar as instrument
    public init() {
        let instrument = Instrument[.guitar]
        self.instrument = instrument
        self.definitions = []
    }

    // /// Init a Chords Database with **ChordPro** JSON
    // public init(json: String, fileURL: URL?) throws {
    //     do {
    //         let data = Data(json.utf8)
    //         let database = try JSONUtils.decode(data, struct: ChordPro.Instrument.self)
    //         let result = ChordsDatabase.processDatabase(database: database, fileURL: fileURL)
    //         self.instrument = result.instrument
    //         self.definitions = result.definitions
    //     } catch {
    //         throw error
    //     }
    // }

    /// Init the database with an URL
    public init(url: URL) throws {
        do {
            let data = try Data(contentsOf: url)
            let database = try JSONUtils.decode(data, struct: ChordPro.Instrument.self)
            let result = ChordsDatabase.processDatabase(database: database, fileURL: url)
            self.instrument = result.instrument
            self.definitions = result.definitions
        } catch {
            throw error
        }
    }

    /// Init the database with an instrument
    /// - Parameter instrument: The ``Instrument`` of the database
    /// - Throws: An error when it can not load a database
    public init(instrument: Instrument) throws {
        do {
            if let bundle = instrument.bundle {
                let database = try Bundle.module.decode(ChordPro.Instrument.self, from: bundle)
                let result = ChordsDatabase.processDatabase(database: database, bundle: instrument.bundle)
                self.instrument = result.instrument
                self.definitions = result.definitions
            } else if let url = instrument.fileURL {
                let data = try Data(contentsOf: url)
                let database = try JSONUtils.decode(data, struct: ChordPro.Instrument.self)
                let result = ChordsDatabase.processDatabase(database: database, fileURL: url)
                self.instrument = result.instrument
                self.definitions = result.definitions
            } else {
                throw ChordProviderError.databaseNotFound
            }
        } catch {
            throw error
        }
    }
}

extension ChordsDatabase {

    private static func processDatabase(
        database: ChordPro.Instrument,
        bundle: String? = nil,
        fileURL: URL? = nil
    ) -> (instrument: Instrument, definitions: [ChordDefinition]) {
        let instrument = Instrument(
            kind: Instrument.Kind(rawValue: database.instrument.type) ?? .guitar,
            label: database.instrument.description,
            tuning: database.tuning,
            bundle: bundle,
            fileURL: fileURL
        )
        /// Get all chord definitions
        var definitions: [ChordDefinition] = []
        for chord in database.chords {
            if let result = ChordDefinition(chord: chord, instrument: instrument) {
                definitions.append(result)
            }
        }
        definitions.sort(
            using: [
                KeyPathComparator(\.baseFret), KeyPathComparator(\.frets.description)
            ]
        )
        return (instrument, definitions)
    }
}

//
//  Chord+Instrument.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

public struct ChordsDatabase: Codable, Sendable, Equatable {
    /// The instrument
    public var instrument: Instrument
    /// The chord definitions
    public var definitions: [ChordDefinition] = []
    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the instrument
        case instrument
    }
}

extension ChordsDatabase {

    /// Init an empty database
    public init() {
        let instrument = Instrument[.guitar]
        self.instrument = instrument
        self.definitions = []
    }

    /// Init the database with **ChordPro** JSON
    public init(json: String, fileURL: URL?) throws {
        do {
            let data = Data(json.utf8)
            let database = try JSONUtils.decode(data, struct: ChordPro.Instrument.self)
            let result = ChordsDatabase.processDatabase(database: database, fileURL: fileURL)
            self.instrument = result.instrument
            self.definitions = result.definitions
        } catch {
            throw error
        }
    }


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
                print("ERROR")
                self.instrument = Instrument[.guitar]
                self.definitions = []
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

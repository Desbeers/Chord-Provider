//
//  ChordsDatabase+init.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Additional init's for a Chord Database
extension ChordsDatabase {

    /// Init a Chords Database with all known values
    /// - Parameters:
    ///   - instrument: The ``Instrument`` for the definitions
    ///   - definitions: The ``ChordDefinitions``
    public init(instrument: Instrument, definitions: [ChordDefinition]) {
        self.instrument = instrument
        self.definitions = definitions
    }

    /// Init the database with an URL
    public init(url: URL) throws(ChordProviderError) {
        do {
            let data = try Data(contentsOf: url)
            let database = try JSONUtils.decode(data, struct: ChordPro.Instrument.self)
            let result = ChordsDatabase.processDatabase(database: database, fileURL: url)
            self.instrument = result.instrument
            self.definitions = result.definitions
            self.errors = result.errors
        } catch ChordProviderError.jsonDecoderError(let error, let context) {
            throw .jsonDecoderError(error: error, context: context)
        } catch CocoaError.fileReadNoSuchFile {
            throw .fileNotFound(url: url)
        } catch {
            throw .databaseImportError(
                error: error.localizedDescription
            )
        }
    }

    /// Init the database with an instrument
    /// - Parameter instrument: The ``Instrument`` of the database
    /// - Throws: An error when it can not load a database
    public init(instrument: Instrument) throws(ChordProviderError) {
        do {
            if let bundle = instrument.bundle {
                let database = try Bundle.module.decode(ChordPro.Instrument.self, from: bundle)
                let result = ChordsDatabase.processDatabase(database: database, bundle: instrument.bundle)
                self.instrument = result.instrument
                self.definitions = result.definitions
            } else {
                /// This should not happen because this function is only for build-in instruments
                throw ChordProviderError.databaseNotFound
            }
        } catch {
            throw .databaseImportError(error: error.localizedDescription)
        }
    }
}

extension ChordsDatabase {

    private static func processDatabase(
        database: ChordPro.Instrument,
        bundle: String? = nil,
        fileURL: URL? = nil
    ) -> (instrument: Instrument, definitions: [ChordDefinition], errors: [ChordProviderError]) {
        let instrument = Instrument(
            kind: Instrument.Kind(rawValue: database.instrument.type) ?? .guitar,
            label: database.instrument.description,
            tuning: database.tuning,
            bundle: bundle,
            fileURL: fileURL
        )
        var errors: [ChordProviderError] = []
        /// Get all chord definitions
        var definitions: [ChordDefinition] = []
        for chord in database.chords {
            do {
                let definition = try ChordDefinition(chord: chord, instrument: instrument)
                definitions.append(definition)
            } catch {
                let result = "<b>\(chord.description)</b>\n \(error.description)"
                errors.append(.databaseImportWarning(warning: result))
            }
        }
        definitions.sort()
        return (instrument, definitions, errors)
    }
}

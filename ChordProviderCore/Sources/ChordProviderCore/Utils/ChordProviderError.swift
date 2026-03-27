//
//  ChordProviderError.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// All errors that can happen in Chord Provider Core
public enum ChordProviderError: LocalizedError {

    /// A file is not found
    case fileNotFound
    /// A database is not found
    case databaseNotFound
    /// JSON decoder error
    case jsonDecoderError(error: String)
    /// There are no chords defined
    case noChordsDefined
    /// File could not be saved
    case fileNotSaved(error: String)
    /// Error when imprting a database
    case databaseImportError(error: String)
    /// Error when exporting a database
    case databaseExportError(error: String)

    /// The description of the error
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            "The file is not found"
        case .fileNotSaved:
            "Could not save the file"
        case .databaseNotFound:
            "The database is not found"
        case .jsonDecoderError(let error):
            error
        case .noChordsDefined:
            "No chords are defined"
        case .databaseImportError:
            "Import Failed"
        case .databaseExportError:
            "Export Failed"
        }
    }

    /// The reason of the error
    public var failureReason: String? {
        switch self {
        case .fileNotFound:
            "The file is not found"
        case .fileNotSaved(let error):
            error
        case .databaseNotFound:
            "The database is not found"
        case .jsonDecoderError(let error):
            error
        case .noChordsDefined:
            "No chords are defined"
        case .databaseImportError(let error):
            error
        case .databaseExportError(let error):
            error
        }
    }

    /// The optional recovery suggestion
    public var recoverySuggestion: String? {
        switch self {
        case .fileNotFound:
            "The file is not found"
        case .databaseNotFound:
            "The database is not found"
        case .jsonDecoderError:
            "It looks like the file is not valid JSON"
        case .noChordsDefined:
            "No chords are defined"
        case .databaseImportError:
            "It looks like the file is not a valid JSON ChordPro configuration"
        case .databaseExportError, .fileNotSaved:
            nil
        }
    }
}

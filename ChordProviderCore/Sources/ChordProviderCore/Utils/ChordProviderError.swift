//
//  ChordProviderError.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// All errors that can happen in Chord Provider Core
public enum ChordProviderError: LocalizedError, Equatable {

    /// A file is not found
    case fileNotFound(url: URL)
    /// A database is not found
    case databaseNotFound
    /// JSON decoder error
    case jsonDecoderError(error: String, context: String? = nil)
    /// There are no chords defined
    case noChordsDefined
    /// File could not be saved
    case fileNotSaved(error: String)
    /// Warnings when importing a database
    case databaseImportWarnings(warnings: String)
    // A single warnings when importing a database
    case databaseImportWarning(warning: String)
    /// Error when importing a database
    case databaseImportError(error: String, context: String? = nil)
    /// Error when exporting a database
    case databaseExportError(error: String)
    /// Error when try to edit a directive
    case directiveNotEditable(error: String)

    /// The description of the error
    public var description: String {
        switch self {
        case .fileNotFound:
            "The file is not found"
        case .fileNotSaved:
            "Could not save the file"
        case .databaseNotFound:
            "The database is not found"
        case .jsonDecoderError:
            "JSON decoder error"
        case .databaseImportWarnings:
            "The Chords Database have incorrect chords"
        case .databaseImportWarning:
            "The import has a warning"
        case .noChordsDefined:
            "No chords are defined"
        case .databaseImportError:
            "The database is not imported"
        case .databaseExportError:
            "Export Failed"
        case .directiveNotEditable:
            "The directive is not editable"
        }
    }

    /// The error description of the status
    public var errorDescription: String? {
        switch self {
        case .jsonDecoderError(let error, _):
            error
        case .databaseImportError(_, let context):
            context
        case .databaseImportWarnings:
            "You can export your database without those chords to clear the warnings"
        case .databaseImportWarning:
            failureReason
        case .fileNotFound(let url):
            "<b>\(url.lastPathComponent)</b> was not found"
        default:
            nil
        }
    }

    /// The reason of the error
    public var failureReason: String? {
        switch self {
        case .fileNotSaved(let error):
            error
        case .databaseNotFound:
            "The database is not found"
        case .jsonDecoderError(_, let context):
            context
        case .noChordsDefined:
            "No chords are defined"
        case .fileNotFound:
            "The file might be moved or deleted"
        case .databaseImportWarnings(let warnings):
            warnings
        case .databaseImportWarning(let warning):
            warning
        case .databaseImportError(let error, _):
            error
        case .databaseExportError(let error):
            error
        case .directiveNotEditable(let error):
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
            nil
        case .directiveNotEditable:
            "The directive contains too many errors"
        case .databaseImportWarnings:
            "Some chord definitions are ignored"
        case .databaseImportWarning:
            nil
        case .databaseExportError, .fileNotSaved:
            nil
        }
    }
}

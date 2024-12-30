//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The database with chords in  **ChordPro** JSON format
struct ChordsDatabaseDocument: FileDocument {
    /// The UTType to export
    static var readableContentTypes: [UTType] { [.json] }
    /// The log to export
    var string: String
    /// Init the struct
    init(string: String) {
        self.string = string
    }
    /// Init the configuration
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .utf8)
        else {
            throw AppError.readDocumentError
        }
        self.string = string
    }
    /// Save the exported Log
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = string.data(using: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        return .init(regularFileWithContents: data)
    }
}

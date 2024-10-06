//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// Define the **ChordPro** log as plain text
struct ChordsDatabaseDocument: FileDocument {
    /// The UTType to export
    static var readableContentTypes: [UTType] { [.json] }
    /// The log to export
    var string: String
    /// Init the struct
    init(string: String) {
        self.string = string
    }
    /// Black magic
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        string = String(decoding: data, as: UTF8.self)
    }
    /// Save the exported Log
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = string.data(using: .utf8) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        return .init(regularFileWithContents: data)
    }
}

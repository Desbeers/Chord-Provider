//
//  ChordsDatabaseDocument.swift
//  Chords Database
//
//  Created by Nick Berendsen on 27/10/2022.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var cdb: UTType {
        UTType(importedAs: "nl.desbeers.cdb")
    }
}

struct ChordsDatabaseDocument: FileDocument {
    var text: String

    init(text: String = "default") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.cdb] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

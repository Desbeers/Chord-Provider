//
//  Make_chordsDocument.swift
//  Shared
//
//  Created by Nick Berendsen on 28/11/2020.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "nl.desbeers.pro")
    }
}

struct ChordProDocument: FileDocument {
    
    var text: String
    
    @AppStorage("showEditor") var showEditor: Bool = false

    init(text: String = "{t: A new song}") {
        self.text = text
        //showEditor = true
    }

    static var readableContentTypes: [UTType] { [.plainText] }

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

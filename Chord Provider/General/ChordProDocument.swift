//
//  ChordProDocument.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The ChordProDocument for Chord Provider
struct ChordProDocument: FileDocument {
    /// The text for a new song
    static let newText: String = "{title: A new song}\n{subtitle: A new artist}"
    /// Build a song max one time per second
    let buildSongDebouncer = Debouncer(duration: 1)
    /// The file extensions Chord Provider can open
    static let fileExtension: [String] = ["crd", "pro", "chopro", "cpm", "chordpro", "txt"]
    /// The `UTType` for a ChordPro document
    static var readableContentTypes: [UTType] { [.chordProDocument] }
    /// The content of the ChordPro file
    var text: String
    /// Init the text
    init(text: String = newText) {
        self.text = text
    }
    /// Init the configuration
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }

    /// Write the document
    /// - Parameter configuration: The document configuration
    /// - Returns: A file in the file system
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

extension UTType {

    // MARK: The `UTType` for a `ChordPro` document

    /// The `UTType` for a ChordPro document
    static let chordProDocument =
        UTType(importedAs: "nl.desbeers.Chord-Provider.chordpro")
}

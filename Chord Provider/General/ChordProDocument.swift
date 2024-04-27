//
//  ChordProDocument.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The ChordProDocument for Chord Provider
struct ChordProDocument: FileDocument {
    /// The text for a new song
    static let newSong: String = "A new song"
    static let newArtist: String = "A new artist"
    static let newText: String = "{title: \(newSong)}\n{artist: \(newArtist)}\n\n"
    /// The file extensions Chord Provider can open
    static let fileExtension: [String] = ["chordpro", "cho", "crd", "chopro", "chord", "pro"]
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
        guard let data = configuration.file.regularFileContents, let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }

    /// Write the document
    /// - Parameter configuration: The document configuration
    /// - Returns: A file in the file system
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard
            let data = text.data(using: .utf8)
        else {
            throw ChordProviderError.writeDocumentError
        }
        return .init(regularFileWithContents: data)
    }
}

extension UTType {

    // MARK: The `UTType` for a `ChordPro` document

    /// The `UTType` for a ChordPro document
    static let chordProDocument =
    UTType(importedAs: "org.chordpro")
}

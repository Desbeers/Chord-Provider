//
//  ChordProDocument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The ChordProDocument for **Chord Provider**
struct ChordProDocument: FileDocument {
    /// The title for a new song
    static let newTitle: String = "A new song"
    /// The artist for a new song
    static let newArtist: String = "A new artist"
    /// The document text for a new song
    static let newText: String = "{title: \(newTitle)}\n{artist: \(newArtist)}\n\n"
    /// The file extensions Chord Provider can open
    static let fileExtension: [String] = ["chordpro", "cho", "crd", "chopro", "chord", "pro"]
    /// The `UTType` for a ChordPro document
    static var readableContentTypes: [UTType] { [.chordProSong] }
    /// The content of the ChordPro file
    var text: String
    /// Init the text
    init(text: String = newText) {
        self.text = text
    }
    /// Init the configuration
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = String(decoding: data, as: UTF8.self)
    }

    /// Write the document
    /// - Parameter configuration: The document configuration
    /// - Returns: A file in the file system
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard
            let data = text.data(using: .utf8)
        else {
            throw AppError.writeDocumentError
        }
        return .init(regularFileWithContents: data)
    }
}

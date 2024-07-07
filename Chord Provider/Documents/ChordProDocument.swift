//
//  ChordProDocument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The ChordProDocument for **Chord Provider**
public struct ChordProDocument: FileDocument {
    /// The title for a new song
    public static let newTitle: String = "A new song"
    /// The artist for a new song
    public static let newArtist: String = "A new artist"
    /// The document text for a new song
    public static let newText: String = "{title: \(newTitle)}\n{artist: \(newArtist)}\n\n"
    /// The file extensions Chord Provider can open
    public static let fileExtension: [String] = ["chordpro", "cho", "crd", "chopro", "chord", "pro"]
    /// The `UTType` for a ChordPro document
    public static var readableContentTypes: [UTType] { [.chordProSong] }
    /// The content of the ChordPro file
    public var text: String
    /// Init the text
    public init(text: String = newText) {
        self.text = text
    }
    /// Init the configuration
    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw AppError.readDocumentError
        }
        /// Replace any Windows line endings
        text = String(decoding: data, as: UTF8.self).replacingOccurrences(of: "\r\n", with: "\n")
    }
    /// Write the document
    /// - Parameter configuration: The document configuration
    /// - Returns: A file in the file system
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard
            let data = text.data(using: .utf8)
        else {
            throw AppError.writeDocumentError
        }
        return .init(regularFileWithContents: data)
    }
}

/// The `FocusedValueKey` for the current document
public struct DocumentFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    public typealias Value = FileDocumentConfiguration<ChordProDocument>
}

public extension FocusedValues {
    /// The value of the document key
    var document: DocumentFocusedValueKey.Value? {
        get {
            self[DocumentFocusedValueKey.self]
        }
        set {
            self[DocumentFocusedValueKey.self] = newValue
        }
    }
}

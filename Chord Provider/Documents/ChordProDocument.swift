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
        guard
            let data = configuration.file.regularFileContents,
            let text = String(data: data, encoding: .utf8)
        else {
            throw AppError.readDocumentError
        }
        /// Replace any Windows line endings
        self.text = text.replacingOccurrences(of: "\r\n", with: "\n")
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

extension ChordProDocument {

    static func getSongTemplateContent(settings: AppSettings) -> String {
        if
            settings.application.useCustomSongTemplate,
            let persistentURL = UserFileBookmark.getBookmarkURL(UserFileItem.customSongTemplate) {
            /// Get access to the URL
            _ = persistentURL.startAccessingSecurityScopedResource()
            let data = try? String(contentsOf: persistentURL, encoding: .utf8)
            /// Stop access to the URL
            persistentURL.stopAccessingSecurityScopedResource()
            return data ?? ChordProDocument.newText
        } else {
            return ChordProDocument.newText
        }
    }
}

/// The `FocusedValueKey` for the current document
struct DocumentFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = FileDocumentConfiguration<ChordProDocument>
}

extension FocusedValues {
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

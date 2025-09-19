//
//  ChordProDocument.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// A document in **ChordPro** format, a simple text format for the notation of lyrics with chords
struct ChordProDocument: FileDocument {
    /// The title for a new song
    static let newTitle: String = "A new song"
    /// The artist for a new song
    static let newArtist: String = "A new artist"
    /// The document text for a new song
    static let newText: String = "{title \(newTitle)}\n{artist \(newArtist)}\n\n"
    /// The file extensions Chord Provider can open
    static let fileExtension: [String] = UTType.chordProSong.tags[.filenameExtension] ?? [""]
    /// The `UTType` for a ChordPro document
    static var readableContentTypes: [UTType] { [.chordProSong] }
    /// The content of the ChordPro file
    var text: String
    /// The optional template URL
    var templateURL: URL?
    /// Init the text
    init(text: String = "", template: URL? = nil) {
        if text.isEmpty {
            self.text = ChordProDocument.getSongTemplateContent()
        } else {
            self.text = text
        }
        self.templateURL = template
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

    /// Get the content of the template for a new song
    /// - Returns: The content as string
    /// - Note: This can optionally from a user defined file in the settings
    static func getSongTemplateContent() -> String {
        let settings = AppSettings.load(id: .mainView)
        if
            settings.application.useCustomSongTemplate,
            let persistentURL = UserFileUtils.Selection.customSongTemplate.getBookmarkURL {
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

extension FocusedValues {
    /// The value of the document
    @Entry var document: FileDocumentConfiguration<ChordProDocument>?
}

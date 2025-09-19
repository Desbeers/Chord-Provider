//
//  ExportDocument.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// An exported **ChordPro** file in PDF format
/// - Note: I cannot name this `PDFDocument` because that is already in use
struct ExportDocument: FileDocument {
    /// The type of image to export
    static var readableContentTypes: [UTType] { [.pdf] }
    /// The PDF to export
    var pdf: Data
    /// Init the struct
    init(pdf: Data?) {
        self.pdf = pdf ?? Data()
    }
    /// Black magic
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw AppError.writeDocumentError
        }
        self.pdf = data
    }
    /// Save the exported PDF
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: pdf as Data)
    }
}

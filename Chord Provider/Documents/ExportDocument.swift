//
//  ExportDocument.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// Define the exported  'ChordProviderDocument'
public struct ExportDocument: FileDocument {
    /// The type of image to export
    public static var readableContentTypes: [UTType] { [.pdf] }
    /// The PDF to export
    public var pdf: Data
    /// Init the struct
    public init(pdf: Data?) {
        self.pdf = pdf ?? Data()
    }
    /// Black magic
    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw AppError.writeDocumentError
        }
        self.pdf = data
    }
    /// Save the exported PDF
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: pdf as Data)
    }
}

//
//  ExportDocument.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// Define the exported  'ChordProviderDocument'
struct ExportDocument: FileDocument {
    /// The type of image to export
    static var readableContentTypes: [UTType] { [.pdf] }
    /// The image to export
    var image: NSData
    /// Init the struct
    init(image: NSData?) {
        self.image = image ?? NSData()
    }
    /// Black magic
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.image = NSData(data: data)
    }
    /// Save the exported image
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: image as Data)
    }
}

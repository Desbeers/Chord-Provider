// MARK: - FileDocument: the chordpro file

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let chordProDocument =
        UTType(importedAs: "nl.desbeers.Chord-Provider.pro")
}

/// The ChordProDocument for Chord Provider
struct ChordProDocument: FileDocument {
    
    @AppStorage("showEditor") var showEditor: Bool = false
    /// The filebrowser 'refresh' toggle
    @AppStorage("refreshList") var refreshList: Bool = false
    static let newText: String = "{title: A new song}\n{subtitle: A new artist}"
    var text: String

    init(text: String = newText) {
        self.text = text
        showEditor = true
    }

    static var readableContentTypes: [UTType] { [.chordProDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
        showEditor = false
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        print("Saving file")
        /// Update the sidebar
        refreshList.toggle()
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

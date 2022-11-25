// MARK: - FileDocument: the chordpro file

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let chordProDocument =
        UTType(importedAs: "nl.desbeers.Chord-Provider.chordpro")
}

/// The ChordProDocument for Chord Provider
struct ChordProDocument: FileDocument {
    /// The filebrowser 'refresh' toggle
    @AppStorage("refreshList") var refreshList: Bool = false
    static let newText: String = "{title: A new song}\n{subtitle: A new artist}"
    let buildSongDebouncer = Debouncer(duration: 1)
    static let fileExtension: [String] = ["crd", "pro", "chopro", "cpm", "chordpro", "txt"]
    var text: String
    init(text: String = newText) {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.chordProDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        /// Update the sidebar
        refreshList.toggle()
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

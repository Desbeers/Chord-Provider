import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let chordProDocument =
        UTType(importedAs: "nl.desbeers.Chord-Provider.pro")
}

struct ChordProDocument: FileDocument {
    
    @AppStorage("showEditor") var showEditor: Bool = false
    /// Sidebar songlist
    @AppStorage("refreshList") var refreshList: Bool = false

    var text: String

    init(text: String = "{t: A new song}") {
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
        /// Update the sidebar
        refreshList.toggle()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        print("Saving file")
        /// Update the sidebar
        refreshList.toggle()
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

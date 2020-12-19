import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let chordProDocument =
        UTType(importedAs: "nl.desbeers.Chord-Provider.pro")
}

struct ChordProDocument: FileDocument {
    
    @AppStorage("showEditor") var showEditor: Bool = false
    
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
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        print("Saving file")
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

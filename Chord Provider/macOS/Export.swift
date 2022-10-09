//
//  Export.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// The SwiftUI 'export' button
struct ExportButtonView: View {
    let song: Song
    @State private var exportFile = false
    @State private var image: NSImage?
    var body: some View {
        Button(action: {
            renderSong()
        }, label: {
            Label("Export song", systemImage: "square.and.arrow.up")
        })
        .fileExporter(isPresented: $exportFile,
                      document: ImageDocument(image: image),
                      contentType: .png, defaultFilename: "\(song.artist ?? "Artist") - \(song.title ?? "Title")",
                      onCompletion: { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        })
    }
    @MainActor private func renderSong() {
        let renderer = ImageRenderer(content: SongExportView(song: song))
        renderer.scale = 3.0
        image = renderer.nsImage
        exportFile = true
    }
}

/// The 'Song View' rendered by the SwiftUI `ImageRenderer`
struct SongExportView: View {
    let song: Song
    var body: some View {
        VStack {
            Text(song.title ?? "Title")
                .font(.title)
            Text(song.artist ?? "Artist")
                .font(.title2)
            SongRenderView(song: song, scale: 1)
        }
        .padding()
        .frame(width: 1200, alignment: .center)
        .preferredColorScheme(.light)
        .background(.white)
    }
}

/// Define the exported  'ImageDocument'
struct ImageDocument: FileDocument {
    /// The type of image to export
    static var readableContentTypes: [UTType] { [.png] }
    /// The image to export
    var image: NSImage
    /// Init the struct
    init(image: NSImage?) {
        self.image = image ?? NSImage()
    }
    /// Black magic
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let image = NSImage(data: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.image = image
    }
    /// Save the exported image
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let imageRep = NSBitmapImageRep(data: (image.tiffRepresentation!))
        let pngData = imageRep?.representation(using: .png, properties: [:])
        return FileWrapper(regularFileWithContents: pngData!)
    }
}

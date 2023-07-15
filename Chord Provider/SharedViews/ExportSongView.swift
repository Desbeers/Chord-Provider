//
//  ExportSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the song export button
struct ExportSongView: View {
    /// The document
    @FocusedBinding(\.document)
    private var document: ChordProDocument?
    /// The ``Song``
    var song: Song {
        ChordPro.parse(text: document?.text ?? "", transpose: 0)
    }
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as image
    @State private var image: Data?

    /// The body of the `View`
    var body: some View {
        // swiftlint:disable:next trailing_closure
        Button(
            action: {
                renderSong()
            },
            label: {
                Label("Export song…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song")
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(image: image),
            contentType: .pdf,
            defaultFilename: "\(song.artist ?? "Artist") - \(song.title ?? "Title")",
            onCompletion: { result in
                if case .success = result {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        )
    }
    /// Render the song as a PDF
    @MainActor
    private func renderSong() {
        if let pdf = ExportSong.createPDF(song: song) {
            image = Data(referencing: pdf)
            exportFile = true
        }
    }
}

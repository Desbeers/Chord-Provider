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
    /// The song as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        // swiftlint:disable:next trailing_closure
        Button(
            action: {
                pdf = try? Data(contentsOf: song.exportURL)
                exportFile = true
            },
            label: {
                Label("Export song…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song")
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: pdf),
            contentType: .pdf,
            defaultFilename: song.exportName,
            onCompletion: { result in
                if case .success = result {
                    print("Success")
                } else {
                    print("Failure")
                }
            }
        )
    }
}

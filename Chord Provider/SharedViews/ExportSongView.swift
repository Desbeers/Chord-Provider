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
    /// The scene
    @FocusedObject private var scene: SceneState?
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
                exportFile = true
            },
            label: {
                Label("Export as PDF…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song as PDF")
        .disabled(document == nil || scene == nil)
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: scene?.pdf),
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

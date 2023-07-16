//
//  ExportSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View for the Export Button`
struct ExportSongView: View {
    /// The scene
    @FocusedObject private var scene: SceneState?
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        // swiftlint:disable:next trailing_closure
        Button(
            action: {
                if let scene {
                    pdf = try? Data(contentsOf: scene.song.exportURL)
                    exportFile = true
                }
            },
            label: {
                Label("Export as PDF…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song as PDF")
        .disabled(scene == nil)
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: pdf),
            contentType: .pdf,
            defaultFilename: scene?.song.exportName,
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

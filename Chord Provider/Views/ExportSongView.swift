//
//  ExportSongView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for a ``Song`` export
struct ExportSongView: View {
    /// The scene
    @FocusedValue(\.scene)
    private var sceneState: SceneState?
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        // swiftlint:disable:next trailing_closure
        Button(
            action: {
                if let sceneState {
                    /// Get the PDF
                    pdf = try? Data(contentsOf: sceneState.song.exportURL)
                    /// Show the export dialog
                    exportFile = true
                }
            },
            label: {
                Label("Export as PDF…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song as PDF")
        .disabled(sceneState == nil)
        .fileExporter(
            isPresented: $exportFile,
            document: ExportDocument(pdf: pdf),
            contentType: .pdf,
            defaultFilename: sceneState?.song.exportName,
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

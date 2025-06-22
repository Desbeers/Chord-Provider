//
//  ExportSongButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` with a button for a ``Song`` export
struct ExportSongButton: View {
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as PDF
    @State private var pdf: Data?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if let sceneState {
                    Task {
                        do {
                            _ = try await sceneState.exportSongToPDF()
                            /// Get the PDF
                            pdf = try? Data(contentsOf: sceneState.song.metadata.exportURL)
                            /// Show the export dialog
                            exportFile = true
                        } catch {
                            sceneState.errorAlert = error.alert()
                        }
                    }
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
            contentTypes: [.pdf],
            defaultFilename: sceneState?.song.metadata.exportName,
            onCompletion: { result in
                switch result {
                case .success(let url):
                    Logger.application.notice("Export song to \(url.lastPathComponent, privacy: .public) completed")
                case .failure(let error):
                    Logger.application.error("Export song error: \(error.localizedDescription, privacy: .public)")
                }
            },
            onCancellation: {
                Logger.application.notice("Export canceled")
            }
        )
    }
}

//
//  ExportSongButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

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
                    LogUtils.shared.setLog(
                        type: .info,
                        category: .fileAccess,
                        message: "Export song to \(url.lastPathComponent) completed"
                    )
                case .failure(let error):
                    LogUtils.shared.setLog(
                        type: .error,
                        category: .fileAccess,
                        message: "Export song error: \(error.localizedDescription)"
                    )
                }
            },
            onCancellation: {
                LogUtils.shared.setLog(
                    type: .info,
                    category: .fileAccess,
                    message: "Export canceled"
                )
            }
        )
    }
}

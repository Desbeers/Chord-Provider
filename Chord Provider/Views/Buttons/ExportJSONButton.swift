//
//  ExportJSONButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` with a button for a ``ChordProviderCore/Song`` in JSON export
struct ExportJSONButton: View {
    /// The current song
    let song: Song?
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as JSON
    @State private var json: String?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if let song {
                    /// Get the JSON
                    json = try? JSONUtils.encode(song)
                    /// Show the export dialog
                    exportFile = true
                }
            },
            label: {
                Label("Export as JSON…", systemImage: "square.and.arrow.up")
            }
        )
        .help("Export your song as JSON")
        .disabled(song == nil)
        .fileExporter(
            isPresented: $exportFile,
            document: JSONDocument(string: json ?? ""),
            contentTypes: [.json],
            defaultFilename: song?.metadata.exportName,
            onCompletion: { result in
                switch result {
                case .success(let url):
                    LogUtils.shared.setLog(
                        level: .info,
                        category: .fileAccess,
                        message: "Export song to \(url.lastPathComponent) completed"
                    )
                case .failure(let error):
                    LogUtils.shared.setLog(
                        level: .error,
                        category: .fileAccess,
                        message: "Export song error: \(error.localizedDescription)"
                    )
                }
            },
            onCancellation: {
                LogUtils.shared.setLog(
                    level: .info,
                    category: .fileAccess,
                    message: "Export canceled"
                )
            }
        )
        .fileDialogMessage(LocalizedStringKey("Export JSON"))
    }
}

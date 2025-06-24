//
//  ExportJSONButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` with a button for a ``Song`` in JSON export
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
                    json = ChordProParser.encode(song)
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

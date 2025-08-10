//
//  ExportBasicButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` with a button for a ``Song`` in BASIC export
struct ExportBasicButton: View {
    /// The current song
    let output: [C64View.Output]
    /// The name of the song
    let name: String
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as JSON
    @State private var basic: String?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                basic = output.map(\.code).joined(separator: "\n") + "\n"
                exportFile = true
            },
            label: {
                Label("Export BASIC", systemImage: "square.and.arrow.up")
            }
        )
        .disabled(output.isEmpty)
        .help("Export your song in BASIC")
        .fileExporter(
            isPresented: $exportFile,
            document: BASICDocument(string: basic ?? ""),
            contentTypes: [.basicSong],
            defaultFilename: name,
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
        .fileDialogMessage(LocalizedStringKey("Export BASIC"))
    }
}

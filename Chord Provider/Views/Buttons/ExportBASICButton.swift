//
//  ExportBASICButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` with a button for a ``Song`` in BASIC export
struct ExportBASICButton: View {
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
                    LogUtils.shared.log(
                        .init(
                            type: .info,
                            category: .fileAccess,
                            message: "Export song to \(url.lastPathComponent)"
                        )
                    )
                case .failure(let error):
                    LogUtils.shared.log(
                        .init(
                            type: .error,
                            category: .fileAccess,
                            message: "Export song error: \(error.localizedDescription)"
                        )
                    )
                }
            },
            onCancellation: {
                LogUtils.shared.log(
                    .init(
                        type: .info,
                        category: .fileAccess,
                        message: "Export canceled"
                    )
                )
            }
        )
        .fileDialogMessage(LocalizedStringKey("Export BASIC"))
    }
}

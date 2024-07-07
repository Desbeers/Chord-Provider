//
//  PrintPDFView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import ChordProShared

/// SwiftUI `View` for the Print Button
struct PrintPDFView: View {
    /// The scene state in the environment
    @FocusedValue(\.sceneState) private var sceneState: SceneState?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if let sceneState, let pdf = sceneState.exportSongToPDF() {
                    /// Show the print dialog
                    AppKitUtils.printDialog(exportURL: pdf.url)
                }
            },
            label: {
                Label("Print…", systemImage: "printer")
            }
        )
        .help("Print your song")
        .disabled(sceneState == nil)
    }
}

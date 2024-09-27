//
//  PrintPDFButton.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the Print Button
struct PrintPDFButton: View {
    /// The label for the button
    let label: String
    /// The observable state of the scene in the environment
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
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
                Label(label, systemImage: "printer")
            }
        )
        .help("Print a PDF of the song")
        .disabled(sceneState == nil)
    }
}

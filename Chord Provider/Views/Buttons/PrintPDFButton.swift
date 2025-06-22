//
//  PrintPDFButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the Print Button
struct PrintPDFButton: View {
    /// The label for the button
    let label: String
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                Task {
                    if let sceneState {
                        do {
                            _ = try await sceneState.exportSongToPDF()
                            AppKitUtils.printDialog(exportURL: sceneState.song.metadata.exportURL)
                        } catch {
                            sceneState.errorAlert = error.alert()
                        }
                    }
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

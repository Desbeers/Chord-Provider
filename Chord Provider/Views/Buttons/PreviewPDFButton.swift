//
//  PreviewPDFButton.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for a PDF preview button
struct PreviewPDFButton: View {
    /// The label for the button
    let label: String
    /// Bool if we have to replace the current preview
    var replacePreview: Bool = false
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        Button(
            action: {
                if sceneState.preview.data == nil || replacePreview {
                    Task {
                        await showPreview()
                    }
                } else {
                    sceneState.preview.data = nil
                }
            },
            label: {
                Label(label, systemImage: sceneState.preview.data == nil ? "eye" : "eye.fill")
            }
        )
        .help("Preview of the PDF")
    }
    /// Show a preview of the PDF
    func showPreview() async {
        if let pdf = await sceneState.exportSongToPDF() {
            /// The preview is not outdated
            sceneState.preview.outdated = false
            /// Show the preview
            sceneState.preview.data = pdf.data
        }
    }
}

extension PreviewPDFButton {

    /// Update the preview of the current document
    struct UpdatePreview: View {
        /// The body of the `View`
        var body: some View {
            PreviewPDFButton(
                label: "Update Preview",
                replacePreview: true
            )
            .labelStyle(.titleOnly)
            .padding(8)
            .background(Color(nsColor: .textColor).opacity(0.04).cornerRadius(10))
            .background(
                Color(nsColor: .textBackgroundColor)
                    .cornerRadius(10)
                    .shadow(
                        color: .secondary.opacity(0.1),
                        radius: 8,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
            )
            .padding()
        }
    }
}

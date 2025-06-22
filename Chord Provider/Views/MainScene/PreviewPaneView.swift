//
//  PreviewPaneView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with the preview pane
struct PreviewPaneView: View {
    /// The PDF data
    let data: Data
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the View
    var body: some View {
        AppKitUtils.PDFKitRepresentedView(data: data)
            .overlay(alignment: .top) {
                if sceneState.preview.outdated {
                    PreviewPDFButton.UpdatePreview()
                }
            }
            .overlay(alignment: .topLeading) {
                Image(systemName: "text.document")
                    .help("Drag me to export")
                    .foregroundStyle(sceneState.song.settings.style.theme.foregroundMedium)
                    .font(.largeTitle)
                    .padding()
                    .draggable(sceneState.preview)
            }
            .onChange(of: sceneState.song.content) {
                sceneState.preview.outdated = true
            }
    }
}

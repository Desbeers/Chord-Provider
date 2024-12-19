//
//  PreviewPaneView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with the preview pane
struct PreviewPaneView: View {
    /// The PDF data
    let data: Data
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The observable state of the document
    @FocusedValue(\.document) private var document: FileDocumentConfiguration<ChordProDocument>?
    /// The body of the View
    var body: some View {
        Divider()
        AppKitUtils.PDFKitRepresentedView(data: data)
            .overlay(alignment: .top) {
                if sceneState.preview.outdated {
                    PreviewPDFButton.UpdatePreview()
                }
            }
            .onChange(of: document?.document.text) {
                sceneState.preview.outdated = true
            }
    }
}

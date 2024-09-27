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
    /// The document in the environment
    @FocusedValue(\.document) private var document: FileDocumentConfiguration<ChordProDocument>?
    /// Optional annotations in the PDF
    @State private var annotations: [(userName: String, contents: String)] = []
    /// The body of the View
    var body: some View {
        Divider()
        AppKitUtils.PDFKitRepresentedView(data: data, annotations: $annotations)
            .overlay(alignment: .top) {
                if sceneState.preview.outdated {
                    PreviewPDFButtonView.UpdatePreview()
                }
            }
            .onChange(of: document?.document.text) {
                sceneState.preview.outdated = true
            }
    }
}

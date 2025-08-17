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
    @State private var data: Data?
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState

    @State private var isHovering: Bool = false
    /// The body of the View
    var body: some View {
        VStack {
            if let data {
                AppKitUtils.PDFKitRepresentedView(data: data)
                    .overlay(alignment: .top) {
                        if sceneState.preview.outdated {
                            PreviewPDFButton.UpdatePreview()
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        Image(systemName: "text.document")
                            .help("Drag me to export")
                            .foregroundStyle(sceneState.settings.style.fonts.label.color)
                            .font(.system(size: 20))
                            .padding()
                            .opacity(isHovering ? 1 : 0.1)
                            .draggable(sceneState.preview)
                            .onHover { hover in
                                isHovering = hover
                            }
                    }
            } else {
                Color(sceneState.settings.style.theme.background)
            }
        }
        .animation(.default, value: isHovering)
        .animation(.default, value: data)
        .onChange(of: sceneState.song.content) {
            sceneState.preview.outdated = true
        }
        .task(id: sceneState.preview.data) {
            if let data = sceneState.preview.data {
                try? await Task.sleep(for: .milliseconds(100))
                self.data = data
            }
        }
    }
}

//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the toolbar
struct ToolbarView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        HStack {
            sceneState.showEditorButton
            Group {
                sceneState.songPagingPicker
                    .pickerStyle(.segmented)
                sceneState.instrumentPicker
                    //.pickerStyle(.segmented)
                sceneState.transposeMenu
                sceneState.chordsMenu
            }
            /// Disable the buttons when showing a preview
            .disabled(sceneState.preview.data != nil)
            PreviewPDFButton(label: "Preview the PDF")
            ShareButton()
        }
    }
}

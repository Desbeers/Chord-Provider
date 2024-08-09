//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the toolbar
struct ToolbarView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The scene state
    @Environment(SceneState.self) private var sceneState
    /// The ChordPro document
    let document: ChordProDocument
    /// The body of the `View`
    var body: some View {
        HStack {
            sceneState.showEditorButton
            Group {
                sceneState.songPagingPicker
                    .pickerStyle(.segmented)
                sceneState.chordDisplayOptions.instrumentPicker
                    .pickerStyle(.segmented)
                sceneState.transposeMenu
                sceneState.chordsMenu
            }
            /// Disable the buttons when showing a preview
            .disabled(sceneState.preview.data != nil)
            PreviewPDFButtonView(label: "Preview the PDF")
            ShareButtonView()
        }
    }
}

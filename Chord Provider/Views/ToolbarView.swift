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
    /// The body of the `View`
    var body: some View {
        Group {
            sceneState.songPagingPicker
                .pickerStyle(.segmented)
            sceneState.chordDisplayOptions.instrumentPicker
                .pickerStyle(.segmented)
            sceneState.transposeMenu
            sceneState.chordsMenu
            sceneState.showEditorButton
            sceneState.quicklook
            sceneState.songShareLink
        }
    }
}

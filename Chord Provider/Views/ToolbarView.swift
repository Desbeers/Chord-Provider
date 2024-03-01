//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the toolbar
struct ToolbarView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The scene state
    @Environment(SceneState.self) private var sceneState
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The body of the `View`
    var body: some View {
        Group {
#if !os(macOS)
            sceneState.showSettingsToggle
#endif
            appState.songPagingPicker
                .pickerStyle(.segmented)
            chordDisplayOptions.instrumentPicker
                .pickerStyle(.segmented)
            sceneState.transposeMenu
            appState.chordsMenu
            sceneState.showEditorButton
            sceneState.songShareLink
        }
    }
}

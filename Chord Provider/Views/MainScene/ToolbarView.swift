//
//  ToolbarView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the toolbar
struct ToolbarView: CustomizableToolbarContent {
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "editor") {
            sceneState.showEditorButton
        }
        ToolbarItem(id: "pager") {
            sceneState.songPagingPicker
                .pickerStyle(.segmented)
                .disabled(sceneState.songRender != .standard)
        }
        ToolbarItem(id: "instrument") {
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
                .disabled(sceneState.songRender != .standard)
                .backport.glassEffect()
        }
        ToolbarItem(id: "transpose") {
            sceneState.transposeMenu
                .disabled(sceneState.songRender != .standard)
        }
        ToolbarItem(id: "chords") {
            sceneState.chordsMenu
                .disabled(sceneState.songRender != .standard)
        }
        ToolbarItem(id: "preview") {
            PreviewPDFButton(label: "Preview PDF")
                .disabled(sceneState.songRender == .c64)
        }
        ToolbarItem(id: "share") {
            /// `SwiftUI ShareLink` sucks on macOS
            ShareButton()
        }
    }
}

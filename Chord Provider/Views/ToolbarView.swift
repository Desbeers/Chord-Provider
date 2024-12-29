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
                .disabled(sceneState.preview.data != nil)
        }
        ToolbarItem(id: "instrument") {
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
                .disabled(sceneState.preview.data != nil)
        }
        ToolbarItem(id: "transpose") {
            sceneState.transposeMenu
                .disabled(sceneState.preview.data != nil)
        }
        ToolbarItem(id: "chords") {
            sceneState.chordsMenu
                .disabled(sceneState.preview.data != nil)
        }
        ToolbarItem(id: "preview") {
            PreviewPDFButton(label: "Preview PDF")
        }
        ToolbarItem(id: "share") {
            ShareButton()
        }
    }
}

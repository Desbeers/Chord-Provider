//
//  FontSizeButtons.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` with buttons to resize the editor font
/// - Note: Unfortunately, this cannot be placed in a `Menu` because it does not proper update its state.
struct FontSizeButtons: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The observable state of the scene
    @FocusedValue(\.sceneState) private var sceneState: SceneStateModel?
    /// The range of font sizes
    private let fontSizeRange = Editor.Settings.fontSizeRange
    /// The body of the `View`
    var body: some View {
        Group {
            Button {
                appState.settings.editor.fontSize += 1
            } label: {
                Label("Increase Editor Font", systemImage: "plus")
            }
            .keyboardShortcut("+")
            .disabled(appState.settings.editor.fontSize == fontSizeRange.upperBound)
            Button {
                appState.settings.editor.fontSize -= 1
            } label: {
                Label("Decrease Editor Font", systemImage: "minus")
            }
            .keyboardShortcut("-")
            .disabled(appState.settings.editor.fontSize == fontSizeRange.lowerBound)
        }
        .disabled(sceneState == nil || sceneState?.showEditor == false)
    }
}

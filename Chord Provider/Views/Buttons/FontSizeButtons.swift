//
//  FontSizeButtons.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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
    private let fontSizeRange = ChordProEditor.Settings.fontSizeRange
    /// The body of the `View`
    var body: some View {
        Group {
            Button {
                appState.settings.editor.fontSize += 1
            } label: {
                Text("Increase Editor Font")
            }
            .keyboardShortcut("+")
            .disabled(appState.settings.editor.fontSize == fontSizeRange.upperBound)
            Button {
                appState.settings.editor.fontSize -= 1
            } label: {
                Text("Decrease Editor Font")
            }
            .keyboardShortcut("-")
            .disabled(appState.settings.editor.fontSize == fontSizeRange.lowerBound)
        }
        .disabled(sceneState == nil || sceneState?.showEditor == false)
    }
}

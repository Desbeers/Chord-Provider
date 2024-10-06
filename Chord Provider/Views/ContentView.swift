//
//  ContentView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the content
@MainActor struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .mainView)
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            MainView(document: $document, file: file)
        }
        .toolbar {
            ToolbarView()
        }
        /// Give the menubar access to the Scene State
        .focusedSceneValue(\.sceneState, sceneState)
        .environment(sceneState)
    }
}

//
//  ContentView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the content
struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The app state
    @Environment(AppStateModel.self) private var appState
    /// The state of the scene
    @State private var sceneState = SceneStateModel()
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            MainView(document: $document)
                .background(Color.white.colorMultiply(Color.telecaster))
        }
        .toolbar {
            ToolbarView(document: document)
        }
        .toolbarBackground(Color.telecaster)
        /// Give the menubar access to the Scene State
        .focusedSceneValue(\.sceneState, sceneState)
        .task(id: file) {
            sceneState.file = file
        }
        .environment(sceneState)
    }
}

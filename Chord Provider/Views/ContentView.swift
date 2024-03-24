//
//  ContentView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities
import SwiftlyFolderUtilities

/// SwiftUI `View` for the content
struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The app state
    @Environment(AppState.self) private var appState
    /// The state of the scene
    @State private var sceneState = SceneState()
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            MainView(document: $document)
                .background(Color.telecaster.opacity(0.2))
        }
        .toolbar {
            ToolbarView()
        }
        .sheet(
            isPresented: $sceneState.presentTemplate,
            onDismiss: {
                //
            },
            content: {
                TemplateView(document: $document, sceneState: sceneState)
            }
        )
#if os(macOS)
        .onChange(of: sceneState.showPrintDialog) {
            if sceneState.showPrintDialog {
                PrintSongView.printDialog(song: sceneState.song)
                sceneState.showPrintDialog.toggle()
            }
        }
        /// Give the menubar access to the Scene State
        .focusedSceneValue(\.scene, sceneState)
#else
        .sheet(isPresented: $sceneState.showSettings) {
            SettingsView()
        }
#endif
        .task {
            if document.text == ChordProDocument.newText {
                sceneState.presentTemplate = true
            }
        }
        .task(id: file) {
            sceneState.file = file
        }
        .environment(sceneState)
    }
}

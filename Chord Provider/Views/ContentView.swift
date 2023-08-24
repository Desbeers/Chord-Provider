//
//  ContentView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the content
struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The state of the scene
    @StateObject private var sceneState = SceneState()
#if os(visionOS)
    /// Placement of the toolbar
    let placement: ToolbarItemPlacement = .bottomOrnament
#elseif os(iOS)
    /// Placement of the toolbar
    let placement: ToolbarItemPlacement = .topBarTrailing
#endif
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        VStack(spacing: 0) {
            HeaderView(song: sceneState.song, file: file)
                .background(Color.accentColor)
                .foregroundColor(.white)
            MainView(document: $document, song: $sceneState.song, file: file)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .toolbar {
            ToolbarView(song: $sceneState.song)
        }
        .onChange(of: sceneState.showPrintDialog) { dialog in
            if dialog {
                PrintSongView.printDialog(song: sceneState.song)
                sceneState.showPrintDialog.toggle()
            }
        }
        .focusedSceneObject(sceneState)
#else
        MainView(document: $document, song: $sceneState.song, file: file)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HeaderView(song: sceneState.song, file: file)
                        .labelStyle(.titleAndIcon)
                }
                ToolbarItemGroup(placement: placement) {
                    ToolbarView(song: $sceneState.song)
                }
            }
            .toolbarBackground(Color("AccentColor"), for: .automatic)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarColorScheme(.dark, for: .automatic)
            .focusedSceneObject(sceneState)
#endif
    }
}

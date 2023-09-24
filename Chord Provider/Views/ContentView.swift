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
    /// The state of the scene
    @StateObject private var sceneState = SceneState()
    /// Chord Display Options
    @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
    /// Show settings (not for macOS)
    @State private var showSettings: Bool = false
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
            chordDisplayOptions.mirrorToggle
            chordDisplayOptions.instrumentPicker
                .frame(width: 100)
            ToolbarView(song: $sceneState.song)
            ShareSongView()
        }
        .onChange(of: sceneState.showPrintDialog) { dialog in
            if dialog {
                PrintSongView.printDialog(song: sceneState.song)
                sceneState.showPrintDialog.toggle()
            }
        }
        .focusedSceneObject(sceneState)
#elseif os(iOS)
        /// Dividers to avoid scrolling over the toolbars
        VStack(spacing: 0) {
            Divider()
            MainView(document: $document, song: $sceneState.song, file: file)
            Divider()
        }
            .navigationTitle(sceneState.song.title ?? "Chord Provider")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            showSettings.toggle()
                        },
                        label: {
                            Image(systemName: "gear")
                        }
                    )
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    chordDisplayOptions.instrumentPicker
                    chordDisplayOptions.mirrorToggle
                        .buttonStyle(.bordered)
                    ToolbarView(song: $sceneState.song)
                        .buttonStyle(.bordered)
                    ToolbarView.FolderSelector()
                        .labelStyle(.titleAndIcon)
                        .buttonStyle(.bordered)
                    ShareSongView()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    HeaderView(song: sceneState.song, file: file)
                        .foregroundColor(.accentColor)
                    ToolbarView.PlayerButtons(song: sceneState.song, file: file)
                }
            }
            .focusedSceneObject(sceneState)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
#elseif os(visionOS)
        MainView(document: $document, song: $sceneState.song, file: file)
            .navigationTitle(sceneState.song.title ?? "Chord Provider")
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    chordDisplayOptions.mirrorButton
                    ToolbarView.FolderSelector()
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    HeaderView(song: sceneState.song, file: file)
                    ToolbarView.PlayerButtons(song: sceneState.song, file: file)
                }
                ToolbarItemGroup(placement: .bottomOrnament) {
                    ToolbarView(song: $sceneState.song)
                    ShareSongView()
                }
            }
            .focusedSceneObject(sceneState)
#endif
    }
}

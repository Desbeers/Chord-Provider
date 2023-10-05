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
        Group {
#if os(macOS)
            VStack(spacing: 0) {
                HeaderView()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                MainView(document: $document)
                    .background(Color.telecaster.opacity(0.2))
            }
            .toolbar {
                ToolbarView.Pager()
                    .pickerStyle(.segmented)
                chordDisplayOptions.instrumentPicker
                    .frame(width: 100)
                ToolbarView()
                ShareSongView()
            }
            .onChange(of: sceneState.showPrintDialog) { dialog in
                if dialog {
                    PrintSongView.printDialog(song: sceneState.song)
                    sceneState.showPrintDialog.toggle()
                }
            }
            /// Give the menubar access to the Scene State
            .focusedSceneObject(sceneState)
#elseif os(iOS)
            /// Dividers to avoid scrolling over the toolbars
            VStack(spacing: 0) {
                Divider()
                MainView(document: $document)
                Divider()
            }
            .navigationTitle(sceneState.song.title ?? "Chord Provider")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.telecaster.opacity(0.4))
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
                    ToolbarView.Pager()
                        .pickerStyle(.segmented)
                    chordDisplayOptions.instrumentPicker
                    ToolbarView()
                    ToolbarView.FolderSelector()
                    ShareSongView()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    HeaderView()
                        .foregroundColor(.accentColor)
                    ToolbarView.ChordAsDiagram()
                        .foregroundColor(.accentColor)
                        .tint(.accentColor)
                        .padding(.leading)
                        .toggleStyle(.switch)
                    ToolbarView.PlayerButtons()
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
#elseif os(visionOS)
            MainView(document: $document)
                .navigationTitle(sceneState.song.title ?? "Chord Provider")
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        chordDisplayOptions.mirrorToggle
                        ToolbarView.FolderSelector()
                    }
                    ToolbarItemGroup(placement: .secondaryAction) {
                        HeaderView()
                        ToolbarView.PlayerButtons()
                    }
                    ToolbarItemGroup(placement: .bottomOrnament) {
                        ToolbarView()
                    }
                }
#endif
        }
        .task(id: file) {
            sceneState.file = file
        }
        .environmentObject(sceneState)
    }
}

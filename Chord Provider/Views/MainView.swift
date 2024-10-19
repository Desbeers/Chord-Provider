//
//  MainView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// SwiftUI `View` for the main content
@MainActor struct MainView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) private var appState
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .mainView)
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowserModel.self) private var fileBrowser
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            switch sceneState.status {
            case .loading:
                ProgressView()
            case .ready:
                HeaderView()
                main
            case .error:
                ContentUnavailableView(
                    "Ooops",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Something went wrong")
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .textBackgroundColor))
        .toolbar {
            ToolbarView()
        }
        .task {
            renderSong()
            /// Always open the editor for a new file
            if document.text == appState.standardDocumentContent || document.text == appState.standardDocumentContent + "\n" {
                sceneState.showEditor = true
            }
            sceneState.status = .ready
        }
        .onChange(of: document.text) {
            renderSong()
        }
        .onChange(of: sceneState.song.metaData.transpose) {
            renderSong()
        }
        .onChange(of: appState.settings) {
            renderSong()
        }
        .onChange(of: sceneState.settings) {
            appState.settings.song = sceneState.settings.song
            renderSong()
        }
        .animation(.default, value: sceneState.preview)
        .animation(.smooth, value: sceneState.settings)
        .animation(.default, value: sceneState.song.metaData)
        .animation(.default, value: sceneState.status)
        /// Give the menubar access to the Scene State
        .focusedSceneValue(\.sceneState, sceneState)
        .environment(sceneState)
    }
    /// The main of the `View`
    var main: some View {
        HStack(spacing: 0) {
            if sceneState.showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
                    .transition(.opacity)
                Divider()
            }
            if let data = sceneState.preview.data {
                PreviewPaneView(data: data)
                    .transition(.move(edge: .trailing))
            } else if sceneState.isAnimating {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                let layout = sceneState.settings.song.chordsPosition == .right ?
                AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
                layout {
                    SongView()
                        .background(Color(nsColor: .textBackgroundColor))
                    if sceneState.settings.song.showChords {
                        Divider()
                        ChordsView(document: $document)
                            .background(Color(nsColor: .textBackgroundColor))
                            .shadow(color: .secondary.opacity(0.25), radius: 60)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }

    /// Render the song
    @MainActor private func renderSong() {
        sceneState.song = ChordProParser.parse(
            id: UUID(),
            text: document.text,
            transpose: sceneState.song.metaData.transpose,
            settings: appState.settings,
            fileURL: file
        )
        sceneState.getMedia()
        if let index = fileBrowser.songList.firstIndex(where: { $0.fileURL == file }) {
            fileBrowser.songList[index].title = sceneState.song.metaData.title
            fileBrowser.songList[index].artist = sceneState.song.metaData.artist
            fileBrowser.songList[index].tags = sceneState.song.metaData.tags
        }
    }
}

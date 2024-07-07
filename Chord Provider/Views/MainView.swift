//
//  MainView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog
import ChordProShared
import SwiftlyChordUtilities

/// SwiftUI `View` for the main content
struct MainView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The scene state
    @Environment(SceneState.self) private var sceneState
    /// The observable ``FileBrowser`` class
    @Environment(FileBrowser.self) private var fileBrowser
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            if sceneState.showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
                    .transition(.opacity)
            }
            if let data = sceneState.preview.data {
                PreviewPaneView(data: data)
                    .transition(.opacity)
            } else {
                let layout = sceneState.songDisplayOptions.chordsPosition == .right ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))

                layout {
                    SongView()
                    if sceneState.songDisplayOptions.showChords {
                        Divider()
                        ChordsView(document: $document)
                            .background(Color.telecaster.opacity(0.2))
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .task {
            renderSong()
            /// Always open the editor for a new file
            if document.text == ChordProDocument.newText {
                sceneState.showEditor = true
            }
        }
        .onChange(of: document.text) {
            renderSong()
        }
        .onChange(of: sceneState.song.metaData.transpose) {
            renderSong()
        }
        .onChange(of: sceneState.songDisplayOptions) {
            appState.settings.songDisplayOptions = sceneState.songDisplayOptions
            renderSong()
        }
        .onChange(of: sceneState.chordDisplayOptions.displayOptions) {
            appState.settings.chordDisplayOptions = sceneState.chordDisplayOptions.displayOptions
            renderSong()
        }
        .onChange(of: appState.settings.songDisplayOptions.general) {
            sceneState.songDisplayOptions.general = appState.settings.songDisplayOptions.general
            renderSong()
        }
        .onChange(of: appState.settings.chordDisplayOptions.general) {
            sceneState.chordDisplayOptions.displayOptions.general = appState.settings.chordDisplayOptions.general
            renderSong()
        }
        .animation(.default, value: sceneState.preview)
        .animation(.default, value: sceneState.showEditor)
        .animation(.default, value: appState.settings.editor)
        .animation(.default, value: appState.settings.songDisplayOptions)
        .animation(.default, value: appState.settings.chordDisplayOptions)
    }
    /// Render the song
    @MainActor
    private func renderSong() {
        sceneState.song = ChordPro.parse(
            id: UUID(),
            text: document.text,
            transpose: sceneState.song.metaData.transpose,
            instrument: sceneState.chordDisplayOptions.displayOptions.instrument,
            fileURL: sceneState.file
        )
        sceneState.song.displayOptions = sceneState.songDisplayOptions
        if let index = fileBrowser.songList.firstIndex(where: { $0.fileURL == sceneState.file }) {
            fileBrowser.songList[index].title = sceneState.song.metaData.title
            fileBrowser.songList[index].artist = sceneState.song.metaData.artist
            fileBrowser.songList[index].tags = sceneState.song.metaData.tags
        }
//        Task {
//            do {
//                let export = try SongExport.export(
//                    song: sceneState.song,
//                    chordDisplayOptions: sceneState.chordDisplayOptions.displayOptions
//                )
//                try export.pdf.write(to: sceneState.exportURL)
//            } catch {
//                Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
//            }
//        }
    }
}

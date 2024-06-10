//
//  MainView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog
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
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// The body of the `View`
    var body: some View {
        let layout = appState.settings.chordsPosition == .right ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
        HStack(spacing: 0) {
            layout {
                SongView()
                if appState.settings.showChords {
                    Divider()
                    ChordsView(document: $document)
                        .background(Color.telecaster.opacity(0.2))
                }
            }
            if sceneState.showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
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
        .onChange(of: appState.settings.general) {
            renderSong()
        }
        .onChange(of: chordDisplayOptions.displayOptions) {
            renderSong()
        }
        .animation(.default, value: sceneState.showEditor)
        .animation(.default, value: appState.settings)
    }
    /// Render the song
    @MainActor
    private func renderSong() {
        sceneState.song = ChordPro.parse(
            id: UUID(),
            text: document.text,
            transpose: sceneState.song.metaData.transpose,
            instrument: chordDisplayOptions.displayOptions.instrument,
            fileURL: sceneState.file
        )
        if let index = fileBrowser.songList.firstIndex(where: { $0.fileURL == sceneState.file }) {
            fileBrowser.songList[index].title = sceneState.song.metaData.title
            fileBrowser.songList[index].artist = sceneState.song.metaData.artist
            fileBrowser.songList[index].tags = sceneState.song.metaData.tags
        }
        Task {
            do {
                let export = try SongExport.export(
                    song: sceneState.song,
                    generalOptions: appState.settings.general,
                    chordDisplayOptions: chordDisplayOptions.displayOptions
                )
                try export.pdf.write(to: sceneState.exportURL)
            } catch {
                Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
}

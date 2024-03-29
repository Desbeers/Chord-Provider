//
//  MainView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the main content
struct MainView: View {
    /// The app state
    @Environment(AppState.self) private var appState
    /// The scene state
    @Environment(SceneState.self) private var sceneState
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
            Task { @MainActor in
                await document.buildSongDebouncer.submit {
                    await renderSong()
                }
            }
        }
        .onChange(of: sceneState.song.transpose) {
            renderSong()
        }
        .onChange(of: chordDisplayOptions.instrument) {
            renderSong()
        }
        .animation(.default, value: sceneState.showEditor)
        .animation(.default, value: appState.settings)
    }
    /// Render the song
    @MainActor
    private func renderSong() {
        sceneState.song = ChordPro.parse(
            text: document.text,
            transpose: sceneState.song.transpose,
            instrument: chordDisplayOptions.instrument
        )
        let options = Song.DisplayOptions(
            label: .grid,
            scale: 1,
            chords: appState.settings.showInlineDiagrams ? .asDiagram : .asName
        )
        ExportSong.savePDF(song: sceneState.song, options: options)
    }
}

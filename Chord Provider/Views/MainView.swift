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
    @EnvironmentObject private var appState: AppState
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// Chord Display Options
    @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// The body of the `View`
    var body: some View {
        let layout = appState.settings.chordsPosition == .right ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0 ))
        HStack(spacing: 0) {
            layout {
                SongView()
                if appState.settings.showChords {
                    Divider()
                    ChordsView(document: $document)
                        .background(Color.telecaster.opacity(0.2))
                }
            }
            if showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
            }
        }
        .task {
            renderSong()
            /// Always open the editor for a new file
            if document.text == ChordProDocument.newText {
                showEditor = true
            }
        }
        .onChange(of: document.text) { _ in
            Task { @MainActor in
                await document.buildSongDebouncer.submit {
                    renderSong()
                }
            }
        }
        .onChange(of: sceneState.song.transpose) { _ in
            renderSong()
        }
        .onChange(of: chordDisplayOptions.instrument) { _ in
            renderSong()
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: appState.settings)
    }
    /// Render the song
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

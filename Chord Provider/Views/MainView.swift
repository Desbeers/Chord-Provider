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
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// Chord Display Options
    @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @SceneStorage("showChords") var showChords: Bool = true
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            SongView()
            if showEditor {
                EditorView(document: $document)
                    .frame(minWidth: 300)
            }
            if showChords {
                ChordsView(song: sceneState.song)
                    .frame(minWidth: 150)
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
        .onChange(of: sceneState.chordAsDiagram) { _ in
            renderSong()
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
    }
    /// Render the song
    private func renderSong() {
        sceneState.song = ChordPro.parse(
            text: document.text,
            transpose: sceneState.song.transpose,
            instrument: chordDisplayOptions.instrument
        )
        let options = Song.DisplayOptions(
            style: .asGrid,
            scale: 1,
            chords: sceneState.chordAsDiagram ? .asDiagram : .asName
        )
        ExportSong.savePDF(song: sceneState.song, options: options)
    }
}

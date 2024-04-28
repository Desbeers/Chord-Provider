//
//  MainView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
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
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// Chord Display Options
    @Environment(ChordDisplayOptions.self) private var chordDisplayOptions
    /// Build a song max one time per second
        let buildSongDebouncer = Debouncer(duration: 1)
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
            Task {
                await buildSongDebouncer.submit {
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
            text: document.text,
            transpose: sceneState.song.transpose,
            instrument: chordDisplayOptions.instrument,
            fileURL: sceneState.file
        )
        Task {
            do {
                let export = try SongExport.export(song: sceneState.song, options: chordDisplayOptions.displayOptions)
                sceneState.pdfData = export.pdf
                try export.pdf.write(to: sceneState.song.exportURL)
            } catch {
                Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
}

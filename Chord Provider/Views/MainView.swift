//
//  MainView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// Swiftui `View` for the main content
struct MainView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The ``Song``
    @Binding var song: Song
    /// The optional file location
    let file: URL?
    /// Chord Display Options
    @EnvironmentObject private var chordDisplayOptions: ChordDisplayOptions
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The body of the `View`
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                SongView(song: song)
                if sceneState.showEditor {
                    EditorView(document: $document)
                        .frame(minWidth: 300)
                }
#if !os(visionOS)
                if sceneState.showChords {
                    ChordsView(song: song)
                        .frame(minWidth: 150)
                }
#endif
            }
#if os(visionOS)
            .ornament(attachmentAnchor: .scene(alignment: .trailing), contentAlignment: .center) {
                if showChords {
                    ChordsView(song: song)
                        .frame(maxHeight: geometry.size.height)
                        .glassBackgroundEffect()
                        .padding(.leading, 80)
                }
            }
#endif
        }
        .task {
            song = ChordPro.parse(text: document.text, transpose: song.transpose, instrument: chordDisplayOptions.instrument)
            ExportSong.savePDF(song: song)
            /// Always open the editor for a new file
            if document.text == ChordProDocument.newText {
                sceneState.showEditor = true
            }
        }
        .onChange(of: document.text) { _ in
            Task { @MainActor in
                await document.buildSongDebouncer.submit {
                    song = ChordPro.parse(text: document.text, transpose: song.transpose, instrument: chordDisplayOptions.instrument)
                    ExportSong.savePDF(song: song)
                }
            }
        }
        .onChange(of: song.transpose) { _ in
            song = ChordPro.parse(text: document.text, transpose: song.transpose, instrument: chordDisplayOptions.instrument)
        }
        .onChange(of: chordDisplayOptions.instrument) { _ in
            song = ChordPro.parse(text: document.text, transpose: song.transpose, instrument: chordDisplayOptions.instrument)
            ExportSong.savePDF(song: song)
        }
        .animation(.default, value: sceneState.showEditor)
        .animation(.default, value: sceneState.showChords)
    }
}

//
//  MainView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// Swiftui `View` for the main content
struct MainView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The ``Song``
    @Binding var song: Song
    /// The optional file location
    let file: URL?
    /// Bool to show the editor or not
    @SceneStorage("showEditor")
    var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords")
    var showChords: Bool = true
    /// The body of the `View`
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                SongView(song: song)
                if showEditor {
                    EditorView(document: $document)
                        .frame(minWidth: 300)
                }
#if !os(visionOS)
                if showChords {
                    ChordsView(song: song)
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
            song = ChordPro.parse(text: document.text, transpose: song.transpose)
            ExportSong.savePDF(song: song)
            /// Always open the editor for a new file
            if document.text == ChordProDocument.newText {
                showEditor = true
            }
        }
        .onChange(of: document.text) { _ in
            Task { @MainActor in
                await document.buildSongDebouncer.submit {
                    song = ChordPro.parse(text: document.text, transpose: song.transpose)
                    ExportSong.savePDF(song: song)
                }
            }
        }
        .onChange(of: song.transpose) { _ in
            song = ChordPro.parse(text: document.text, transpose: song.transpose)
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
    }
}

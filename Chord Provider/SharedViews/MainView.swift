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
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            SongView(song: song)
            if showChords {
                ChordsView(song: song)
            }
            if showEditor {
                Divider()
                EditorView(document: $document)
                    .frame(minWidth: 300)
            }
        }
        .task(id: document.text) {
            /// Always open the editor for a new file
            if document.text == ChordProDocument.newText {
                showEditor = true
            }
            await document.buildSongDebouncer.submit {
                song = ChordPro.parse(text: document.text, transpose: song.transpose)
            }
        }
        .task(id: song.transpose) {
            song = ChordPro.parse(text: document.text, transpose: song.transpose)
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
        .animation(.default, value: song.text)
        .animation(.default, value: song.chords.map({$0.chordPosition.name}))
    }
}

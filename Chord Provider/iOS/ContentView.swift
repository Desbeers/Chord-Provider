//
//  ContentView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the main content
struct ContentView: View {
    /// Then ChordPro document
    @Binding var document: ChordProDocument
    /// The ``Song``
    @State var song = Song()
    /// The optional file location
    let file: URL?
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// The body of the `View`
    var body: some View {
        HStack {
            SongView(song: song)
                .padding(.top)
            if showEditor {
                Divider()
                EditorView(document: $document)
                    .transition(.scale)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                HeaderView.General(song: song)
                HeaderView.Details(song: song)
                    .labelStyle(.titleAndIcon)
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ToolbarView(song: $song)
            }
        }
        .toolbarBackground(.visible, for: .automatic)
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
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
    }
}

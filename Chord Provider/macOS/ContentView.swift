//
//  ContentView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the main content
struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The ``Song``
    @State var song = Song()
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// The FileBrowser model
    @EnvironmentObject var fileBrowser: FileBrowserModel
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(song: song, file: file)
                .background(Color.accentColor.opacity(0.1))
            HStack(spacing: 0) {
                SongView(song: song)
                if showEditor {
                    Divider()
                    EditorView(document: $document)
                        .frame(minWidth: 300)
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .onDisappear {
            Task { @MainActor in
                if let index = fileBrowser.openWindows.firstIndex(where: {$0.fileURL == file}) {
                    /// Mark window as closed
                    fileBrowser.openWindows.remove(at: index)
                }
            }
        }
        .toolbar {
            ToolbarView(song: $song)
            ExportSongView(song: song)
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
    }
}

//
//  SongView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Song View
struct SongView: View {
    let song: Song
    let file: URL?
    @AppStorage("showChords") var showChords: Bool = true
    @SceneStorage("showEditor") var showEditor: Bool = false
    var body: some View {
        HStack {
            HtmlView(html: (song.html ?? ""))
            if showChords {
                ChordsView(song: song)
                    .transition(.opacity)
            }
        }
    }
}

/// Update the song item
struct SongViewModifier: ViewModifier {

    @Binding var document: ChordProDocument
    @Binding var song: Song
    let file: URL?

    @SceneStorage("showEditor") var showEditor: Bool = false

    func body(content: Content) -> some View {
        content
            .task {
                /// Always open the editor for a new file
                if document.text == ChordProDocument.newText {
                    showEditor = true
                }
                song = ChordPro.parse(text: document.text, file: file ?? nil)
            }
            .onChange(of: document.text) { _ in
                Task {
                    await document.buildSongDebouncer.submit {
                        song = ChordPro.parse(text: document.text, file: file ?? nil)
                    }
                }
            }
    }
}

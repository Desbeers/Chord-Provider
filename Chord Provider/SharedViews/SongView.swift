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
    @SceneStorage("scale") var scale: Double = 1.2
    @SceneStorage("previousScale") var previousScale: Double = 1.2
    /// Pinch to zoom
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = previousScale * value
            }
            .onEnded { value in
                previousScale *= value
            }
    }
    /// The body of the View
    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                SongRenderView(song: song, scale: scale)
                    .gesture(magnificationGesture)
                    .padding()
            }
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
                song = ChordPro.parse(text: document.text, transponse: song.transpose, file: file ?? nil)
            }
            .onChange(of: document.text) { _ in
                Task {
                    await document.buildSongDebouncer.submit {
                        song = ChordPro.parse(text: document.text, transponse: song.transpose, file: file ?? nil)
                    }
                }
            }
            .onChange(of: song.transpose) { _ in
                Task {
                    await document.buildSongDebouncer.submit {
                        song = ChordPro.parse(text: document.text, transponse: song.transpose, file: file ?? nil)
                    }
                }
            }
    }
}

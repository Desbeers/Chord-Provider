//
//  SongView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Song View
struct SongView: View {
    /// The ``Song``
    let song: Song
    /// The optional file URL
    let file: URL?
    /// Bool to show the chords or not
    @AppStorage("showChords") var showChords: Bool = true
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// The scale factor of the `View`
    @SceneStorage("scale") var scale: Double = 1.2
    /// The previous scale factor of the `View`
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
    /// The body of the `View`
    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                SongRenderView(song: song, scale: scale)
                    .gesture(magnificationGesture)
                    .padding()
            }
            if showChords && !showEditor {
                ChordsView(song: song)
                    .transition(.opacity)
            }
        }
    }
}

/// SwiftUI `ViewModifier`  for updating the song item
struct SongViewModifier: ViewModifier {
    /// Thew ChordPro document
    @Binding var document: ChordProDocument
    /// The ``Song``
    @Binding var song: Song
    /// The optional file URL
    let file: URL?
    /// Bool to show the editor or not
    @SceneStorage("showEditor") var showEditor: Bool = false
    /// The body of the `ViewModifier`
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

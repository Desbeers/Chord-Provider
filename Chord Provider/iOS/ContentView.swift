//
//  ContentView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Main View
struct ContentView: View {
    @Binding var document: ChordProDocument
    @State var song = Song()
    let file: URL?
    @SceneStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true

    var body: some View {
        VStack {
            HeaderView(song: song)
                .background(Color.accentColor.opacity(0.1))
                .padding(.bottom)
            HStack {
                SongView(song: song, file: file)
                if showEditor {
                    EditorView(document: $document)
                        .transition(.scale)
                        .shadow(radius: 5)
                }
            }
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

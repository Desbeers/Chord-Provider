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
        HStack {
            SongView(song: song, file: file)
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
                Button {
                    withAnimation {
                        showChords.toggle()
                    }
                } label: {
                    Label(showChords ? "Hide chords" : "Show chords", systemImage: showChords ? "number.square.fill" : "number.square")
                }
                .labelStyle(.titleAndIcon)
                Button {
                    withAnimation {
                        showEditor.toggle()
                    }
                } label: {
                    Label(showEditor ? "Hide editor" : "Edit song", systemImage: showEditor ? "pencil.circle.fill" : "pencil.circle")
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .toolbarBackground(Color.accentColor.opacity(0.1), for: .automatic)
        .toolbarRole(.automatic)
        .toolbarBackground(.visible, for: .automatic)
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

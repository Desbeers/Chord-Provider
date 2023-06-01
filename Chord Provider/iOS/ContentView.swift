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
                Button(action: {
                    song.transpose -= 1
                }, label: {
                    Label("♭", systemImage: "arrow.down")
                        .foregroundColor(song.transpose < 0 ? .accentColor : .primary)
                })
                .labelStyle(.titleAndIcon)
                Button(action: {
                    song.transpose += 1
                }, label: {
                    Label("♯", systemImage: "arrow.up")
                        .foregroundColor(song.transpose > 0 ? .accentColor : .primary)
                })
                .labelStyle(.titleAndIcon)
                Button {
                    withAnimation {
                        showChords.toggle()
                    }
                } label: {
                    Label(showChords ? "Hide chords" : "Show chords", systemImage: showChords ? "number.square.fill" : "number.square")
                        .frame(minWidth: 140, alignment: .leading)
                }
                .labelStyle(.titleAndIcon)
                .disabled(showEditor)
                Button {
                    withAnimation {
                        showEditor.toggle()
                    }
                } label: {
                    Label(showEditor ? "Hide editor" : "Edit song", systemImage: showEditor ? "pencil.circle.fill" : "pencil.circle")
                        .frame(minWidth: 140, alignment: .leading)
                }
                .labelStyle(.titleAndIcon)
            }
        }
        .toolbarBackground(.visible, for: .automatic)
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

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
    let file: URL?
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    @EnvironmentObject var fileBrowser: FileBrowser
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(song: song).background(Color.accentColor.opacity(0.1))
            HStack {
                SongView(song: song, file: file)
                    .frame(minWidth: 400)
                    .padding(.top)
                if showEditor {
                    EditorView(document: $document)
                        .frame(minWidth: 400)
                        .transition(.scale)
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .task {
            if let file = file {
                fileBrowser.openFiles.append(file)
            }
        }
        .onDisappear {
            Task { @MainActor in
                if let index = fileBrowser.openFiles.firstIndex(where: {$0 == file}) {
                    /// Mark window as closed
                    fileBrowser.openFiles.remove(at: index)
                }
            }
        }
        .toolbar {
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
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

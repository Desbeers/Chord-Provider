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
    @SceneStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    @EnvironmentObject var fileBrowser: FileBrowser

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(song: song).background(Color.accentColor.opacity(0.1))
            HStack(spacing: 0) {
                SongView(song: song, file: file)
                    .frame(minWidth: 400, maxWidth: .infinity)
                if showEditor {
                    Divider()
                    EditorView(document: $document)
                        .frame(minWidth: 400)
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .onDisappear {
            Task { @MainActor in
                if let index = fileBrowser.openWindows.firstIndex(where: {$0.songURL == file}) {
                    /// Mark window as closed
                    fileBrowser.openWindows.remove(at: index)
                }
            }
        }
        .toolbar {
            ExportButtonView(song: song)
                .labelStyle(.iconOnly)
                .help("Export your song")
            Button {
                withAnimation {
                    showChords.toggle()
                }
            } label: {
                Label(showChords ? "Hide chords" : "Show chords", systemImage: showChords ? "number.square.fill" : "number.square")
                    .frame(minWidth: 110, alignment: .leading)
            }
            .labelStyle(.titleAndIcon)
            Button {
                withAnimation {
                    showEditor.toggle()
                }
            } label: {
                Label(showEditor ? "Hide editor" : "Edit song", systemImage: showEditor ? "pencil.circle.fill" : "pencil.circle")
                    .frame(minWidth: 110, alignment: .leading)
            }
            .labelStyle(.titleAndIcon)
        }
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

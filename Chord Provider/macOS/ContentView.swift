//
//  ContentView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// SwiftUI `View` for the main content
struct ContentView: View {
    /// Then ChordPro document
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

            Button(action: {
                song.transpose -= 1
            }, label: {
                Label("♭", systemImage: "arrow.down")
                    .font(.title2)
                    .foregroundColor(song.transpose < 0 ? .accentColor : .primary)
            })
            .labelStyle(.titleAndIcon)
            Button(action: {
                song.transpose += 1
            }, label: {
                Label("♯", systemImage: "arrow.up")
                    .font(.title2)
                    .foregroundColor(song.transpose > 0 ? .accentColor : .primary)
            })
            .labelStyle(.titleAndIcon)

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
            ExportSongView(song: song)
                .labelStyle(.iconOnly)
                .help("Export your song")
        }
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

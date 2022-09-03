// MARK: - View: Main View for macOS

/// The main view; on the right of the sidebar.

import SwiftUI

struct ViewContent: View {
    @Binding var document: ChordProDocument
    let file: URL?
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    @EnvironmentObject var mySongs: MySongs
    
    var body: some View {
        VStack(spacing: 0) {
            ViewHeader(song: song).background(Color.accentColor.opacity(0.1))
            HStack {
                ViewSong(song: song, file: file).frame(minWidth: 400).padding(.top)
                if showEditor {
                    ViewEditor(document: $document)
                        .frame(minWidth: 400)
                        //.shadow(radius: 5)
                        //.background(Color(NSColor.textBackgroundColor))
                        .transition(.scale)
                }
            }
        }
        .background(Color(nsColor: .textBackgroundColor))
        .task {
            if let file = file {
                mySongs.openFiles.append(file)
            }
        }
        .onDisappear {
            Task { @MainActor in
                if let index = mySongs.openFiles.firstIndex(where: {$0 == file}) {
                    /// Mark window as closed
                    mySongs.openFiles.remove(at: index)
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
        .modifier(ViewSongModifier(document: $document, song: $song, file: file))
    }
}

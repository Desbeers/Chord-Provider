// MARK: - View: Main View for macOS

/// The main view; on the right of the sidebar.

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    let file: URL?
    @State var song = Song()
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(song: song).background(Color.accentColor.opacity(0.3))
            HSplitView {
                SongView(song: song, file: file).frame(minWidth: 400).padding(.top)
                if showEditor {
                    EditorView(document: $document)
                        .frame(minWidth: 400)
                        .background(Color(NSColor.textBackgroundColor))
                        .transition(.scale)
                }
            }
        }
        /// Hard-coded the foregroundColor because SwiftUI is buggy when switching appearance.
        /// Not great; the buttons don't dim when the application is in the background.
        .toolbar {
            ToolbarItemGroup {
                Button {
                    withAnimation {
                        showChords.toggle()
                    }
                }
                label: {
                    HStack {
                        Image(systemName: showChords ? "number.square.fill" : "number.square")
                        Text(showChords ? "Hide chords" : "Show chords")
                    }
                    .foregroundColor(.secondary)
                }
                Button {
                    withAnimation {
                        showEditor.toggle()
                    }
                }
                label: {
                    Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
                    Text(showEditor ? "Hide editor" : "Edit song")
                }
                .foregroundColor(.secondary)
            }
        }
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
    }
}

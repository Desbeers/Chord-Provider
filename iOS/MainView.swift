// MARK: - View: Main View for iOS

/// The content of the whole application.

import SwiftUI

struct MainView: View {
    @Binding var document: ChordProDocument
    @State var song = Song()
    let file: URL?
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true
    @Environment(\.horizontalSizeClass) var sizeClass

    var body: some View {
        VStack {
            HeaderView(song: song).background(Color.purple.opacity(0.3)).padding(.bottom)
            HStack {
                SongView(song: song, file: file)
                if showEditor {
                    EditorView(document: $document)
                }
            }
        }
        .statusBar(hidden: true)
        .modifier(SongViewModifier(document: $document, song: $song, file: file))
        /// iPhone shows only one ToolbarItem; that's ok because I only like the first item for iPhone anyway :-)
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
                    }
                }
                Button {
                    withAnimation {
                        showEditor.toggle()
                    }
                }
                label: {
                    Image(systemName: showEditor ? "pencil.circle.fill" : "pencil.circle")
                }
            }
        }
    }
}

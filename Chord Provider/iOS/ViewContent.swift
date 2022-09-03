// MARK: - View: Main View for iOS

/// The content of the whole application.

import SwiftUI

struct ViewContent: View {
    @Binding var document: ChordProDocument
    @State var song = Song()
    let file: URL?
    @AppStorage("showEditor") var showEditor: Bool = false
    @AppStorage("showChords") var showChords: Bool = true

    var body: some View {
        VStack {
            ViewHeader(song: song)
                .background(Color.accentColor.opacity(0.1))
                .padding(.bottom)
            HStack {
                ViewSong(song: song, file: file)
                if showEditor {
                    ViewEditor(document: $document)
                        .transition(.scale)
                        .shadow(radius: 5)
                }
            }
        }
        .animation(.default, value: showEditor)
        .animation(.default, value: showChords)
        .modifier(ViewSongModifier(document: $document, song: $song, file: file))
    }
}

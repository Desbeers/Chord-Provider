// MARK: - View: Song View for macOS and iOS

/// HTML views for the song

import SwiftUI

struct ViewSong: View {
    @ObservedObject var song: Song
    let file: URL?
    @AppStorage("showChords") var showChords: Bool = true
    @AppStorage("showEditor") var showEditor: Bool = false
    
    var body: some View {
        /// Stupid hack to get the view using full height
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    ViewHtml(html: (song.html ?? "")).frame(height: geometry.size.height)
                    if showChords && !showEditor {
                        ViewChords(song: song).frame(width: 140, height: geometry.size.height)
                            .transition(.scale)
                    }
                }
            }
            .frame(height: geometry.size.height)
        }
    }
}

// MARK: - ViewModifier: Modify song view

/// This will update the Song View when the document is changed.

struct ViewSongModifier: ViewModifier {

    @Binding var document: ChordProDocument
    @Binding var song: Song
    let file: URL?

    func body(content: Content) -> some View {
        content
            .onAppear(
                perform: {
                    song = ChordPro.parse(document: document, file: file ?? nil)
                }
            )
            .onChange(of: document.text) { _ in
                song = ChordPro.parse(document: document, file: file ?? nil)
            }
    }
}

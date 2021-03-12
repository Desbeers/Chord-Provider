//  MARK: - View: Song View for macOS and iOS

/// HTML views for the song

import SwiftUI

struct SongView: View {
    @ObservedObject var song: Song
    @AppStorage("showChords") var showChords: Bool = true
    @AppStorage("showEditor") var showEditor: Bool = false
    
    var body: some View {
        /// Stupid hack to get the view using full height
        GeometryReader { g in
            ScrollView {
                HStack {
                    HtmlView(html: (song.html ?? "")).frame(height: g.size.height)
                    if showChords && !showEditor {
                        ChordsView(song: song).frame(width: 140,height: g.size.height)
                            .transition(.scale)
                    }
                }
            }.frame(height: g.size.height)
        }
    }
}

//  MARK: - ViewModifier: Modify song view

/// This will update the Song View when the document is changed.

struct SongViewModifier: ViewModifier {

    @Binding var document: ChordProDocument
    @Binding var song: Song

    func body(content: Content) -> some View {
        content
            .onAppear(
                perform: {
                    song = ChordPro.parse(document: document)
                }
            )
            .onChange(of: document.text) { newValue in
                song = ChordPro.parse(document: document)
            }
    }
}


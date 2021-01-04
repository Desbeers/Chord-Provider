//  MARK: - View: Song View for macOS and iOS

/// HTML views for the song and the chords.

import SwiftUI

struct SongView: View {
    @ObservedObject var song: Song
    @AppStorage("showChords") var showChords: Bool = true
    
    var body: some View {
        /// Stupid hack to get the view using full height
        GeometryReader { g in
            ScrollView {
                HStack {
                    HtmlView(html: (song.html ?? "")).frame(height: g.size.height)
                    if showChords {
                        HtmlView(html: (song.htmlchords ?? "leeg")).frame(width: 140,height: g.size.height)
                    }
                }
            }.frame(height: g.size.height)
        }
    }
}

//  MARK: - ViewModifier: Modify song view

/// This will update the Song View when the document is changed.

struct SongViewModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme

    @Binding var document: ChordProDocument
    @Binding var song: Song
    let diagrams: [Diagram]
    
    func body(content: Content) -> some View {
        content
            .onAppear(
                perform: {
                    song = ChordPro.parse(document: document, diagrams: diagrams)
                }
            )
            .onChange(of: document.text) { newValue in
                song = ChordPro.parse(document: document, diagrams: diagrams)
            }
            .onChange(of: colorScheme) {color in
                /// Reload the html views with the new colors.
                song.html = BuildSong(song: song, chords: false)
                song.htmlchords = BuildSong(song: song, chords: true)
            }
    }
}

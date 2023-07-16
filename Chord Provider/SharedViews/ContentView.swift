//
//  ContentView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the content
struct ContentView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The optional file location
    let file: URL?
    /// The ``Song``
    @State private var song = Song()
    /// The body of the `View`
    var body: some View {
#if os(macOS)
        VStack(spacing: 0) {
            HeaderView(song: song, file: file)
                .background(Color.accentColor)
                .foregroundColor(.white)
            MainView(document: $document, song: $song, file: file)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .toolbar {
            ToolbarView(song: $song)
        }
#endif

#if os(iOS)
        MainView(document: $document, song: $song, file: file)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HeaderView(song: song, file: file)
                        .labelStyle(.titleAndIcon)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ToolbarView(song: $song)
                }
            }
            .toolbarBackground(Color("AccentColor"), for: .automatic)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarColorScheme(.dark, for: .automatic)
#endif
    }
}

//
//  ContentView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the main content
struct ContentView: View {
    /// Then ChordPro document
    @Binding var document: ChordProDocument
    /// The ``Song``
    @State var song = Song()
    /// The optional file location
    let file: URL?
    /// The body of the `View`
    var body: some View {
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
        .toolbarBackground(Color("AccentColor").gradient.opacity(0.3), for: .automatic)
        .toolbarBackground(.visible, for: .automatic)
    }
}

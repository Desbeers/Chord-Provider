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
    @State var song = Song()
    /// The FileBrowser model
    @EnvironmentObject var fileBrowser: FileBrowserModel
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(song: song, file: file)
                .background(Color.accentColor.saturation(0.6))
                .foregroundColor(.white)
            MainView(document: $document, song: $song, file: file)
        }
        .background(Color(nsColor: .textBackgroundColor))
        .onDisappear {
            Task { @MainActor in
                if let index = fileBrowser.openWindows.firstIndex(where: {$0.fileURL == file}) {
                    /// Mark window as closed
                    fileBrowser.openWindows.remove(at: index)
                }
            }
        }
        .toolbar {
            ToolbarView(song: $song)
            ExportSongView(song: song)
        }
    }
}

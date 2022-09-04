//
//  SongView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Song View
struct SongView: View {
    let song: Song
    let file: URL?
    @AppStorage("showChords") var showChords: Bool = true
    @AppStorage("showEditor") var showEditor: Bool = false
    var body: some View {
        /// Stupid hack to get the view using full height
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    HtmlView(html: (song.html ?? "")).frame(height: geometry.size.height)
                    if showChords && !showEditor {
                        ChordsView(song: song).frame(width: 140, height: geometry.size.height)
                            .transition(.scale)
                    }
                }
            }
            .frame(height: geometry.size.height)
        }
    }
}

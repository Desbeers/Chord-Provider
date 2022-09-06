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
    @SceneStorage("showEditor") var showEditor: Bool = false
    var body: some View {
        HStack {
            HtmlView(html: (song.html ?? ""))
            if showChords {
                ChordsView(song: song)
                    .transition(.opacity)
            }
        }
    }
}

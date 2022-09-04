//
//  Song.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The struct of a song
struct Song {
    var title: String?
    var artist: String?
    var capo: String?
    var key: String?
    var tempo: String?
    var time: String?
    var year: String?
    var album: String?
    var tuning: String?
    var html: String?
    var path: URL?
    var musicpath: URL?
    var sections = [Song.Section]()
    var chords = [Chord]()
}

/// Update the song item
struct SongViewModifier: ViewModifier {

    @Binding var document: ChordProDocument
    @Binding var song: Song
    let file: URL?

    func body(content: Content) -> some View {
        content
            .task {
                song = ChordPro.parse(document: document, file: file ?? nil)
            }
            .onChange(of: document.text) { _ in
                song = ChordPro.parse(document: document, file: file ?? nil)
            }
    }
}

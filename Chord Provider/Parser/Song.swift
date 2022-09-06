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

//let buildSongDebouncer = Debouncer(duration: 1)
/// Update the song item
struct SongViewModifier: ViewModifier {

    @Binding var document: ChordProDocument
    @Binding var song: Song
    let file: URL?

    @SceneStorage("showEditor") var showEditor: Bool = false

    func body(content: Content) -> some View {
        content
            .task {
                /// Always open the editor for a new file
                if document.text == ChordProDocument.newText {
                    showEditor = true
                }
                song = await ChordPro.parse(document: document, file: file ?? nil)
            }
            .onChange(of: document.text) { _ in
                Task {
                    await document.buildSongDebouncer.submit {
                        song = await ChordPro.parse(document: document, file: file ?? nil)
                    }
                }
            }
    }
}

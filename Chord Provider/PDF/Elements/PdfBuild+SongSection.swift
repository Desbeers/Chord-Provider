//
//  PdfBuild+SongSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PdfBuild {

    /// A PDF song section item
    ///
    /// - Store the metadata of the song
    /// - Store the page number
    open class SongSection: PdfElement {

        let song: Song
        let counter: PdfBuild.TextPageCounter

        init(song: Song, counter: PdfBuild.TextPageCounter) {
            self.song = song
            self.counter = counter
        }

        open override func draw(rect: inout CGRect) {
            counter.songs.insert(
                SongInfo(
                    title: song.title ?? "Unknown title",
                    artist: song.artist ?? "Unkwon artist",
                    page: counter.pageNumber
                )
            )
        }
    }
}

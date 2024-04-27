//
//  PDFBuild+SongSection.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF song section item
    ///
    /// - Store the metadata of the song
    /// - Store the page number
    open class SongSection: PDFElement {

        let song: Song
        let counter: PDFBuild.PageCounter

        init(song: Song, counter: PDFBuild.PageCounter) {
            self.song = song
            self.counter = counter
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {
            if !calculationOnly {
                counter.songs.append(
                    SongInfo(
                        title: song.title ?? "Unknown title",
                        artist: song.artist ?? "Unkwon artist",
                        page: counter.pageNumber
                    )
                )
            }
        }
    }
}

//
//  PDFBuild+SongTocItem.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation

extension PDFBuild {

    /// A PDF song TOC item
    ///
    /// - Store the metadata of the song
    /// - Store the page number
    open class SongTocItem: PDFElement {

        var songInfo: PDFBuild.SongInfo
        var counter: PDFBuild.PageCounter

        init(songInfo: PDFBuild.SongInfo, counter: PDFBuild.PageCounter) {
            self.songInfo = songInfo
            self.counter = counter
        }

        open override func draw(rect: inout CGRect, calculationOnly: Bool) {

            let startRect = rect
            let tocItem = PDFBuild.Section(
                columns: [.fixed(width: 30), .flexible, .flexible],
                items: [
                    PDFBuild.Text("\(songInfo.page)", attributes: .alignment(.right)),
                    PDFBuild.Text("\(songInfo.title)"),
                    PDFBuild.Text("\(songInfo.artist)")
                ]
            )
            tocItem.draw(rect: &rect, calculationOnly: calculationOnly)
            if !calculationOnly, let index = counter.songs.firstIndex(where: { $0.page == songInfo.page }) {
                let usedRect = CGRect(
                    x: startRect.origin.x,
                    y: startRect.origin.y,
                    width: startRect.width,
                    height: startRect.height - rect.height
                )
                songInfo.toc = usedRect
                counter.songs[index] = songInfo
            }
        }
    }
}

//
//  FolderExport+toc.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 26/04/2024.
//

import Foundation

extension FolderExport {

    static func toc(info: PDFBuild.DocumentInfo, counter: PDFBuild.PageCounter) -> Data {
        let tocBuilder = PDFBuild.Builder(info: info)
        tocBuilder.items.append(PDFBuild.PageBackgroundColor(color: .black))
        tocBuilder.items.append(PDFBuild.Text(info.title, attributes: .exportTitle))
        tocBuilder.items.append(PDFBuild.Text(info.author, attributes: .exportAuthor).padding(PDFBuild.pagePadding))
        tocBuilder.items.append(PDFBuild.Image(.launchIcon))
        tocBuilder.items.append(PDFBuild.PageBreak())
        for (index, song) in counter.songs.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.artist)).enumerated() {
            if index % FolderExport.tocSongsOnPage == 0 {
                switch index {
                case 0:
                    tocBuilder.items.append(PDFBuild.Text("Table of Contents", attributes: .songTitle))
                    tocBuilder.items.append(PDFBuild.Divider(direction: .horizontal).padding(20))
                default:
                    tocBuilder.items.append(PDFBuild.PageBreak())
                }
            }
            tocBuilder.items.append(PDFBuild.SongTocItem(songInfo: song, counter: counter))
        }
        return tocBuilder.generatePdf() as Data
    }
}

//
//  LibraryExport.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/04/2024.
//

import Foundation
import SwiftlyChordUtilities
import SwiftlyFolderUtilities

func libraryExport(files: [FileBrowser.SongItem], options: ChordDefinition.DisplayOptions) -> (pdf: Data, toc: [PdfBuild.SongInfo]) {

    let pdfInfo = PdfBuild.DocumentInfo(
        title: "All songs",
        author: "Chord Provider"
    )

    let builder = PdfBuild.Builder(info: pdfInfo)

    let counter = PdfBuild.TextPageCounter(pageNumber: 0, attributes: .pageCounter)

    builder.pageCounter = counter

    // MARK: Add PDF elements

    builder.items = [
        PdfBuild.PageHeader(
            top: [],
            bottom: [
                counter
            ]
        )
    ]

    try? FolderBookmark.action(bookmark: FileBrowser.bookmark) { _ in

        for song in files.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.artist)) {
            if let fileContents = try? String(contentsOf: song.fileURL, encoding: .utf8) {
                let song = ChordPro.parse(text: fileContents, transpose: 0, instrument: .guitarStandardETuning)
                builder.items.append(contentsOf: SongToPDF.getSongElements(song: song, options: options, counter: counter))
            } else {
                print("No Access for \(song.title)")
            }
            builder.items.append(PdfBuild.PageBreak())
        }
    }

    /// Generate the PDF
    let pdf = builder.generatePdf() as Data

    /// Return the PDF and the list of songs sorted by page
    return (pdf, Array(counter.songs).sorted(using: KeyPathComparator(\.page)))
}

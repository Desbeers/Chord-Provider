//
//  FolderExport+content.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 26/04/2024.
//

import Foundation
import OSLog
import PDFKit
import SwiftlyChordUtilities
import SwiftlyFolderUtilities

extension FolderExport {

    static func content(
        files: [FileBrowser.SongItem],
        options: ChordDefinition.DisplayOptions,
        progress: @escaping (Float) -> Void
    ) -> (data: Data, counter: PDFBuild.PageCounter) {
        /// Check how many pages we need for the title page + TOC and adjust the first paage number
        let startPage = (files.count / FolderExport.tocSongsOnPage) + 2
        let builder = PDFBuild.Builder(info: PDFBuild.DocumentInfo())
        let counter = PDFBuild.PageCounter(startPage: startPage, attributes: .pageCounter)
        builder.pageCounter = counter
        // MARK: Render PDF content
        builder.items = [
            PDFBuild.PageHeader(
                top: [],
                bottom: [
                    counter
                ]
            )
        ]
        try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
            for song in files.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.artist)) {
                if let fileContents = try? String(contentsOf: song.fileURL, encoding: .utf8) {
                    let song = ChordPro.parse(text: fileContents, transpose: 0, instrument: .guitarStandardETuning)
                    builder.items.append(contentsOf: SongExport.getSongElements(song: song, options: options, counter: counter))
                } else {
                    Logger.application.error("No Access to \(song.title, privacy: .public)")
                }
                builder.items.append(PDFBuild.PageBreak())
            }
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) } as Data
        /// Return content and counter
        return (content, counter)
    }
}

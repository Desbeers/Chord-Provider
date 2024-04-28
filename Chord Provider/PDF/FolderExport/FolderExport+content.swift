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

    /// Convert ChordPro files to a PDF
    /// - Parameters:
    ///   - info: The document info for the PDF
    ///   - files: The list of files in a ``FileBrowser/SongItem`` array
    ///   - options: The chord display options
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: The PDF as `Data` and the `PageCounter` class with TOC info
    static func content(
        info: PDFBuild.DocumentInfo,
        files: [FileBrowser.SongItem],
        options: ChordDefinition.DisplayOptions,
        progress: @escaping (Double) -> Void
    ) -> (data: Data, counter: PDFBuild.PageCounter) {
        /// Check how many pages we need for the title page + TOC and adjust the first page number
        let firstPage = (files.count / FolderExport.tocSongsOnPage) + 1
        let builder = PDFBuild.Builder(info: info)
        let counter = PDFBuild.PageCounter(firstPage: firstPage, attributes: .footer + .alignment(.right))
        builder.pageCounter = counter
        // MARK: Render PDF content
        try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
            for song in files.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.artist)) {
                if let fileContents = try? String(contentsOf: song.fileURL, encoding: .utf8) {
                    builder.elements.append(
                        PDFBuild.PageHeaderFooter(
                            header: [],
                            footer: [
                                PDFBuild.Section(
                                    columns: [.flexible, .flexible],
                                    items: [
                                        PDFBuild.Text("\(song.artist)∙\(song.title)", attributes: .footer + .alignment(.left)),
                                        counter
                                    ]
                                )
                            ]
                        )
                    )
                    builder.elements.append(PDFBuild.PageBreak())
                    let song = ChordPro.parse(text: fileContents, transpose: 0, instrument: .guitarStandardETuning)
                    builder.elements.append(contentsOf: SongExport.getSongElements(song: song, options: options, counter: counter))
                } else {
                    Logger.application.error("No Access to \(song.title, privacy: .public)")
                }
            }
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) }
        /// Return content and counter
        return (content, counter)
    }
}

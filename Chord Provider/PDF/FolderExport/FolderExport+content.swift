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
    ///   - counter: The `PDFBuild.PageCounter` class
    ///   - options: The chord display options
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: The PDF as `Data` and the `PageCounter` class with TOC info
    static func content(
        info: PDFBuild.DocumentInfo,
        counter: PDFBuild.PageCounter,
        options: ChordDefinition.DisplayOptions,
        progress: @escaping (Double) -> Void
    ) -> Data {
        let builder = PDFBuild.Builder(info: info)
        builder.pageCounter = counter
        // MARK: Render PDF content
        try? FolderBookmark.action(bookmark: FileBrowser.folderBookmark) { _ in
            for item in counter.tocItems.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.subtitle)) {
                if let file = item.fileURL, let fileContents = try? String(contentsOf: file, encoding: .utf8) {
                    builder.elements.append(
                        PDFBuild.PageHeaderFooter(
                            header: [],
                            footer: [
                                PDFBuild.Section(
                                    columns: [.flexible, .flexible],
                                    items: [
                                        PDFBuild.Text("\(item.subtitle)∙\(item.title)", attributes: .footer + .alignment(.left)),
                                        counter
                                    ]
                                )
                            ]
                        )
                    )
                    builder.elements.append(PDFBuild.PageBreak())
                    let song = ChordPro.parse(
                        text: fileContents,
                        transpose: 0,
                        instrument: .guitarStandardETuning, 
                        fileURL: item.fileURL
                    )
                    builder.elements.append(contentsOf: SongExport.getSongElements(song: song, options: options, counter: counter))
                } else {
                    Logger.application.error("No Access to \(item.title, privacy: .public)")
                }
            }
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) }
        /// Return content and counter
        return content
    }
}

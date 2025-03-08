//
//  FolderExport+content.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog
import PDFKit

extension FolderExport {

    /// Convert ChordPro files to a PDF
    /// - Parameters:
    ///   - documentInfo: The document info for the PDF
    ///   - counter: The `PDFBuild.PageCounter` class
    ///   - appSettings: The application settings
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: The PDF as `Data` and the `PageCounter` class with TOC info
    static func content(
        documentInfo: PDFBuild.DocumentInfo,
        counter: PDFBuild.PageCounter,
        appSettings: AppSettings,
        progress: @escaping (Double) -> Void
    ) async -> Data {
        let builder = PDFBuild.Builder(documentInfo: documentInfo)
        builder.pageCounter = counter
        // MARK: Render PDF content
        for item in counter.tocItems {
            builder.elements.append(
                PDFBuild.PageHeaderFooter(
                    header: [],
                    footer: [
                        PDFBuild.Section(
                            columns: [.flexible, .flexible],
                            items: [
                                PDFBuild.Text(
                                    "\(item.song.metadata.artist)∙\(item.song.metadata.title)",
                                    attributes: .footer + .alignment(.left)
                                ),
                                counter
                            ]
                        )
                    ]
                )
            )
            builder.elements.append(PDFBuild.PageBreak())
            await builder.elements.append(
                contentsOf: SongExport.getSongElements(
                    song: item.song,
                    counter: counter,
                    appSettings: appSettings
                )
            )
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) }
        /// Return content and counter
        return content
    }
}

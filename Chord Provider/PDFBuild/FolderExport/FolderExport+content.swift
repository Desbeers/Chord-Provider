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
    ///   - settings: The application settings
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: The PDF as `Data` and the `PageCounter` class with TOC info
    static func content(
        documentInfo: PDFBuild.DocumentInfo,
        counter: PDFBuild.PageCounter,
        settings: AppSettings,
        progress: @escaping (Double) -> Void
    ) async -> Data {
        let builder = PDFBuild.Builder(documentInfo: documentInfo, settings: settings)
        builder.pageCounter = counter
        // MARK: Render PDF content
        for item in counter.tocItems {
            builder.elements.append(
                PDFBuild.PageHeaderFooter(
                    header: [],
                    footer: [
                        PDFBuild.Section(
                            columns: [.flexible, .fixed(width: 20)],
                            items: [
                                PDFBuild.Text(
                                    "\(item.song.metadata.artist)∙\(item.song.metadata.title)",
                                    attributes: .smallTextFont(settings: settings) + .alignment(.left)
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
                    counter: counter
                )
            )
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) }
        /// Return content and counter
        return content
    }
}

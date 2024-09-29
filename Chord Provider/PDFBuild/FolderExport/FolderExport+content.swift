//
//  FolderExport+content.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
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
    ) -> Data {
        let builder = PDFBuild.Builder(documentInfo: documentInfo)
        builder.pageCounter = counter
        // MARK: Render PDF content
        if let exportFolder = UserFileBookmark.getBookmarkURL(UserFileItem.exportFolder) {
            /// Get access to the URL
            _ = exportFolder.startAccessingSecurityScopedResource()
            for item in counter
                .tocItems
                .sorted(using: KeyPathComparator(\.title))
                .sorted(using: KeyPathComparator(\.subtitle)) {
                if let file = item.fileURL, let fileContents = try? String(contentsOf: file, encoding: .utf8) {
                    builder.elements.append(
                        PDFBuild.PageHeaderFooter(
                            header: [],
                            footer: [
                                PDFBuild.Section(
                                    columns: [.flexible, .flexible],
                                    items: [
                                        PDFBuild.Text(
                                            "\(item.subtitle)∙\(item.title)",
                                            attributes: .footer + .alignment(.left)
                                        ),
                                        counter
                                    ]
                                )
                            ]
                        )
                    )
                    builder.elements.append(PDFBuild.PageBreak())
                    let song = ChordPro.parse(
                        id: item.id,
                        text: fileContents,
                        transpose: 0,
                        settings: appSettings,
                        fileURL: item.fileURL
                    )
                    builder.elements.append(
                        contentsOf: SongExport.getSongElements(
                            song: song,
                            counter: counter
                        )
                    )
                } else {
                    Logger.application.error("No Access to \(item.title, privacy: .public)")
                }
            }
            /// Close access to the URL
            exportFolder.stopAccessingSecurityScopedResource()
        }
        /// Generate the PDF
        let content = builder.generatePdf { page in progress(page) }
        /// Return content and counter
        return content
    }
}

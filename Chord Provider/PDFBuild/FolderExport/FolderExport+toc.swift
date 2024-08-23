//
//  FolderExport+toc.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension FolderExport {

    /// Create a Table of Contents
    /// - Parameters:
    ///   - info: The document info for the PDF
    ///   - tocItems: The items for the TOC
    /// - Returns: The Table of Contents as `Data`
    static func toc(info: PDFBuild.DocumentInfo, counter: PDFBuild.PageCounter) -> Data {
        let tocBuilder = PDFBuild.Builder(info: info)
        tocBuilder.pageCounter = counter
        tocBuilder.elements.append(PDFBuild.PageBackgroundColor(color: .black))
        tocBuilder.elements.append(PDFBuild.Text(info.title, attributes: .exportTitle))
        tocBuilder.elements.append(PDFBuild.Text(info.author, attributes: .exportAuthor).padding(PDFBuild.pagePadding))
        tocBuilder.elements.append(PDFBuild.Image(.launchIcon))
        tocBuilder.elements.append(PDFBuild.PageBreak())
        tocBuilder.elements.append(PDFBuild.Text("Table of Contents", attributes: .pdfTitle))
        tocBuilder.elements.append(PDFBuild.Divider(direction: .horizontal).padding(20))
        for tocInfo in counter
            .tocItems
            .sorted(using: KeyPathComparator(\.title))
            .sorted(using: KeyPathComparator(\.subtitle)) {
            tocBuilder.elements.append(PDFBuild.TOCItem(tocInfo: tocInfo, counter: counter))
        }
        return tocBuilder.generatePdf()
    }
}

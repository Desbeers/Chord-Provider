//
//  FolderExport+toc.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 26/04/2024.
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
        tocBuilder.elements.append(PDFBuild.PageBackgroundColor(color: .black))
        tocBuilder.elements.append(PDFBuild.Text(info.title, attributes: .exportTitle))
        tocBuilder.elements.append(PDFBuild.Text(info.author, attributes: .exportAuthor).padding(PDFBuild.pagePadding))
        tocBuilder.elements.append(PDFBuild.Image(.launchIcon))
        tocBuilder.elements.append(PDFBuild.PageBreak())
        for (index, tocInfo) in counter.tocItems.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.subtitle)).enumerated() {
            if index % FolderExport.tocSongsOnPage == 0 {
                switch index {
                case 0:
                    tocBuilder.elements.append(PDFBuild.Text("Table of Contents", attributes: .songTitle))
                    tocBuilder.elements.append(PDFBuild.Divider(direction: .horizontal).padding(20))
                default:
                    tocBuilder.elements.append(PDFBuild.PageBreak())
                }
            }
            tocBuilder.elements.append(PDFBuild.TOCItem(tocInfo: tocInfo, counter: counter))
        }
        return tocBuilder.generatePdf()
    }
}

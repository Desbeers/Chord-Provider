//
//  SongToPdf+process.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/04/2024.
//

import Foundation
import PDFKit

extension SongToPDF {

    static func process(data: Data, toc: [PdfBuild.SongInfo]) -> PDFDocument? {
        guard
            let newPDF = PDFDocument(data: data)
        else {
            print("ERROR creating PDF")
            return nil
        }

        var counter: Int = 0

        newPDF.outlineRoot = PDFOutline()

        for song in toc {

            /// Internal, the first page number is `0`, so, take one off..
            let page = song.page - 1

            guard let pdfPage = newPDF.page(at: page) else {
                print("ERROR getting PDF page")
                return nil
            }
            let pdfPageRect = pdfPage.bounds(for: PDFDisplayBox.mediaBox)
            let topLeft = CGPoint(x: pdfPageRect.minX, y: pdfPageRect.height + 20)

            let newDest = PDFDestination(page: pdfPage, at: topLeft)
            let newTOCEntry = PDFOutline()

            newTOCEntry.destination = newDest
            newTOCEntry.label = "\(song.artist) - \(song.title)"

            newPDF.outlineRoot?.insertChild(newTOCEntry, at: counter)

            counter += 1
        }
        return newPDF
    }
}

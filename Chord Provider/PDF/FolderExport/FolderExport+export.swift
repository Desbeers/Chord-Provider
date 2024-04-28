//
//  LibraryExport.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 22/04/2024.
//

import Foundation
import SwiftlyChordUtilities
import SwiftlyFolderUtilities
import PDFKit
import OSLog

extension FolderExport {

    /// Export a folder with ChordPro songs
    /// - Parameters:
    ///   - info: The document info for the PDF
    ///   - options: The chord display options
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: A PDFDocument if all well, else an error
    static func export(
        info: PDFBuild.DocumentInfo,
        options: ChordDefinition.DisplayOptions,
        progress: @escaping (Double) -> Void
    ) async throws -> PDFDocument? {

        // MARK: Get the song files
        let files = try files()

        // MARK: Render Content
        let content = FolderExport.content(info: info, files: files, options: options, progress: progress)
        let contentData = content.data
        let counter = content.counter

        // MARK: Render Table of Contents

        let tocData = FolderExport.toc(info: info, counter: counter)

        // MARK: Convert to PDFDocument

        guard
            let tocPDF = PDFDocument(data: tocData),
            let newPDF = PDFDocument(data: contentData)
        else {
            throw ChordProviderError.createPdfError
        }

        // MARK: Add outline

        let toc = counter.tocItems.sorted(using: KeyPathComparator(\.title)).sorted(using: KeyPathComparator(\.subtitle))

        newPDF.outlineRoot = PDFOutline()

        let artists = PDFOutline()
        artists.label = "Artist"
        newPDF.outlineRoot?.insertChild(artists, at: 0)
        let songs = PDFOutline()
        songs.label = "Songs"
        newPDF.outlineRoot?.insertChild(songs, at: 1)

        /// Songs by artist
        var entryCounter: Int = 0
        for song in toc.sorted(using: KeyPathComparator(\.subtitle)) {
            /// Internal, the first page number is `0`, so, take one off..
            let page = song.pageNumber - 1 - counter.firstPage
            guard let pdfPage = newPDF.page(at: page) else {
                throw ChordProviderError.createPdfError
            }
            let pdfPageRect = pdfPage.bounds(for: PDFDisplayBox.mediaBox)
            let topLeft = CGPoint(x: pdfPageRect.minX, y: pdfPageRect.height + 20)
            let newDest = PDFDestination(page: pdfPage, at: topLeft)

            let artistEntry = PDFOutline()
            artistEntry.destination = newDest
            artistEntry.label = "\(song.subtitle) - \(song.title)"
            artists.insertChild(artistEntry, at: entryCounter)
            entryCounter += 1
        }

        /// Songs by title
        entryCounter = 0
        for song in toc.sorted(using: KeyPathComparator(\.title)) {
            /// Internal, the first page number is `0`, so, take one off..
            let page = song.pageNumber - 1 - counter.firstPage
            guard let pdfPage = newPDF.page(at: page) else {
                throw ChordProviderError.createPdfError
            }
            let pdfPageRect = pdfPage.bounds(for: PDFDisplayBox.mediaBox)
            let topLeft = CGPoint(x: pdfPageRect.minX, y: pdfPageRect.height + 20)

            let newDest = PDFDestination(page: pdfPage, at: topLeft)
            let songEntry = PDFOutline()
            songEntry.destination = newDest
            songEntry.label = "\(song.title) - \(song.subtitle)"
            songs.insertChild(songEntry, at: entryCounter)
            entryCounter += 1
        }

        // MARK: Add Front Page
        guard
            let frontPage = tocPDF.page(at: 0)
        else {
            throw ChordProviderError.createPdfError
        }
        /// The first (empty) page of the content will be replaced by the cover
        newPDF.removePage(at: 0)
        newPDF.insert(frontPage, at: 0)

        // MARK: Add TOC with internal links
        for index in stride(from: 0, to: toc.count - 1, by: FolderExport.tocSongsOnPage) {
            let tocPageIndex = (index / FolderExport.tocSongsOnPage) + 1
            guard
                let tocPage = tocPDF.page(at: tocPageIndex)
            else {
                throw ChordProviderError.createPdfError
            }

            for songIndex in index..<(index + FolderExport.tocSongsOnPage) where songIndex < toc.count {

                let song = toc[songIndex]
                guard
                    let destinationPage = newPDF.page(at: song.pageNumber - 2 - counter.firstPage + tocPageIndex)
                else {
                    throw ChordProviderError.createPdfError
                }
                let mediaBox = tocPage.bounds(for: .mediaBox)
                let bounds = CGRect(
                    x: song.rect.origin.x,
                    y: mediaBox.height - song.rect.origin.y - song.rect.height,
                    width: song.rect.width,
                    height: song.rect.height
                )
                let destinationCoordinates = CGPoint(x: 25, y: mediaBox.height)
                let link = PDFAnnotation(
                    bounds: bounds,
                    forType: .link,
                    withProperties: nil
                )
                link.action = PDFActionGoTo(
                    destination: PDFDestination(
                        page: destinationPage,
                        at: destinationCoordinates
                    )
                )
                tocPage.addAnnotation(link)
            }
            /// Insert the new TOC page with the internal links
            newPDF.insert(tocPage, at: tocPageIndex)
        }
        return newPDF
    }
}

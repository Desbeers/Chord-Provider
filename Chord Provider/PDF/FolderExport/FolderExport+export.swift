//
//  LibraryExport.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import Foundation
import SwiftlyChordUtilities
import SwiftlyFolderUtilities
import PDFKit
import OSLog

extension FolderExport {

    /// The status of the export
    enum Status {
        /// Export is in progress
        case progress(Double)
        /// Export is finished
        case finished(Data)
    }

    /// Export a folder with ChordPro songs
    /// - Parameters:
    ///   - info: The document info for the PDF
    ///   - generalOptions: The general options
    ///   - chordDisplayOptions: The chord display options
    /// - Returns: A stream with progress indication and a document when finnished
    static func export(
        info: PDFBuild.DocumentInfo,
        generalOptions: ChordProviderGeneralOptions,
        chordDisplayOptions: ChordDefinition.DisplayOptions
    ) -> AsyncThrowingStream<Status, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let render = try await FolderExport.export(
                        info: info,
                        generalOptions: generalOptions,
                        chordDisplayOptions: chordDisplayOptions
                    ) { page in
                        continuation.yield(Status.progress(page))
                    }
                    if let render {
                        continuation.yield(.finished(render))
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
        }
}

extension FolderExport {

    /// Export a folder with ChordPro songs
    /// - Parameters:
    ///   - info: The document info for the PDF
    ///   - generalOptions: The general options
    ///   - chordDisplayOptions: The chord display options
    ///   - progress: A closure to observe the progress of PDF creation
    /// - Returns: A PDFDocument if all well, else an error
    static func export(
        info: PDFBuild.DocumentInfo,
        generalOptions: ChordProviderGeneralOptions,
        chordDisplayOptions: ChordDefinition.DisplayOptions,
        progress: @escaping (Double) -> Void
    ) async throws -> Data? {

        // MARK: Get the song files
        let files = try files()

        /// Build the TOC to see how many pages we need
        let counter = PDFBuild.PageCounter(firstPage: 0, attributes: .footer + .alignment(.right))
        counter.tocItems = files.map { file in
            PDFBuild.TOCInfo(
                id: UUID(),
                title: file.title,
                subtitle: file.artist,
                fileURL: file.fileURL
            )
        }
        var tocData = FolderExport.toc(info: info, counter: counter)
        let tocPageCount = PDFDocument(data: tocData)?.pageCount ?? 0
        /// Remove one page from the counter
        counter.pageNumber -= 1

        // MARK: Render Content
        let contentData = FolderExport.content(
            info: info,
            counter: counter,
            generalOptions: generalOptions,
            chordDisplayOptions: chordDisplayOptions,
            progress: progress
        )

        // MARK: Render Table of Contents
        tocData = FolderExport.toc(info: info, counter: counter)

        // MARK: Convert to PDFDocument
        guard
            let tocPDF = PDFDocument(data: tocData),
            let newPDF = PDFDocument(data: contentData)
        else {
            throw ChordProviderError.createPdfError
        }

        // MARK: Add outline
        let toc = counter.tocItems
        /// Make the root outline
        newPDF.outlineRoot = PDFOutline()
        /// Add the child items
        let artists = PDFOutline()
        artists.label = "Artist"
        newPDF.outlineRoot?.insertChild(artists, at: 0)
        let songs = PDFOutline()
        songs.label = "Songs"
        newPDF.outlineRoot?.insertChild(songs, at: 1)
        /// Songs by artist
        var entryCounter: Int = 0
        for song in toc.sorted(using: KeyPathComparator(\.subtitle)) {
            let page = song.pageNumber - tocPageCount
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
            let page = song.pageNumber - tocPageCount
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
        /// Use the Dictionary(grouping:) function so that all the items are grouped together by TOC page
        let groupedTOC = Dictionary(grouping: counter.tocItems) { (occurrence: PDFBuild.TOCInfo) -> Int in
            occurrence.tocPageNumber
        }
        let sortedTOC = groupedTOC.sorted(using: KeyPathComparator(\.key))
        for (tocPageIndex, items) in sortedTOC {
            guard
                /// Internal, the first page number is `0`, so, take one extra off..
                let tocPage = tocPDF.page(at: tocPageIndex - 1)
            else {
                throw ChordProviderError.createPdfError
            }
            for item in items.sorted(using: KeyPathComparator(\.pageNumber)) {
                guard
                    let destinationPage = newPDF.page(at: item.pageNumber - tocPageCount + tocPageIndex - 2)
                else {
                    throw ChordProviderError.createPdfError
                }
                let mediaBox = tocPage.bounds(for: .mediaBox)
                let bounds = CGRect(
                    x: item.rect.origin.x,
                    y: mediaBox.height - item.rect.origin.y - item.rect.height,
                    width: item.rect.width,
                    height: item.rect.height
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
            newPDF.insert(tocPage, at: tocPageIndex - 1)
        }
        return newPDF.dataRepresentation()
    }
}

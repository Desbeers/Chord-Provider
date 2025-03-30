//
//  LibraryExport.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
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
    ///   - documentInfo: The document info for the PDF
    ///   - appSettings: The application settings
    /// - Returns: A stream with progress indication and a document when finished
    static func export(
        documentInfo: PDFBuild.DocumentInfo,
        appSettings: AppSettings
    ) -> AsyncThrowingStream<Status, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let render = try await FolderExport.export(
                        documentInfo: documentInfo,
                        appSettings: appSettings
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
    ///   - documentInfo: The document info for the PDF
    ///   - appSettings: The application settings
    ///   - progress: The progress of the folder export
    /// - Returns: A PDFDocument if all well, else an error
    static func export(
        documentInfo: PDFBuild.DocumentInfo,
        appSettings: AppSettings,
        progress: @escaping (Double) -> Void
    ) async throws -> Data? {

        // MARK: Get the song files
        var files = try await files()
        /// Sort the songs
        switch appSettings.application.songListSort {
        case .song:
            files.sort(using: KeyPathComparator(\.metadata.sortTitle))
        case .artist:
            files.sort(using: KeyPathComparator(\.metadata.sortArtist))
        }
        /// Build the TOC to see how many pages we need
        let counter = PDFBuild.PageCounter(firstPage: 0, attributes: .smallTextFont(settings: appSettings) + .alignment(.right))
        counter.tocItems = files.map { file in
            PDFBuild.TOCInfo(
                song: file
            )
        }
        var tocData = FolderExport.toc(documentInfo: documentInfo, counter: counter, appSettings: appSettings)
        let tocPageCount = PDFDocument(data: tocData)?.pageCount ?? 0
        /// Remove one page from the counter
        counter.pageNumber -= 1

        // MARK: Render Content
        let contentData = await FolderExport.content(
            documentInfo: documentInfo,
            counter: counter,
            appSettings: appSettings,
            progress: progress
        )

        // MARK: Render Table of Contents
        tocData = FolderExport.toc(documentInfo: documentInfo, counter: counter, appSettings: appSettings)

        // MARK: Convert to PDFDocument
        guard
            let tocPDF = PDFDocument(data: tocData),
            let newPDF = PDFDocument(data: contentData)
        else {
            throw AppError.createPdfError
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
        for song in toc.sorted(using: KeyPathComparator(\.song.metadata.sortArtist)) {
            let page = song.pageNumber - tocPageCount
            guard let pdfPage = newPDF.page(at: page) else {
                throw AppError.createPdfError
            }
            let pdfPageRect = pdfPage.bounds(for: PDFDisplayBox.mediaBox)
            let topLeft = CGPoint(x: pdfPageRect.minX, y: pdfPageRect.height + 20)
            let newDest = PDFDestination(page: pdfPage, at: topLeft)

            let artistEntry = PDFOutline()
            artistEntry.destination = newDest
            artistEntry.label = "\(song.song.metadata.artist) - \(song.song.metadata.title)"
            artists.insertChild(artistEntry, at: entryCounter)
            entryCounter += 1
        }
        /// Songs by title
        entryCounter = 0
        for song in toc.sorted(using: KeyPathComparator(\.song.metadata.sortTitle)) {
            let page = song.pageNumber - tocPageCount
            guard let pdfPage = newPDF.page(at: page) else {
                throw AppError.createPdfError
            }
            let pdfPageRect = pdfPage.bounds(for: PDFDisplayBox.mediaBox)
            let topLeft = CGPoint(x: pdfPageRect.minX, y: pdfPageRect.height + 20)

            let newDest = PDFDestination(page: pdfPage, at: topLeft)
            let songEntry = PDFOutline()
            songEntry.destination = newDest
            songEntry.label = "\(song.song.metadata.title) - \(song.song.metadata.artist)"
            songs.insertChild(songEntry, at: entryCounter)
            entryCounter += 1
        }

        // MARK: Add Front Page
        guard
            let frontPage = tocPDF.page(at: 0)
        else {
            throw AppError.createPdfError
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
                throw AppError.createPdfError
            }
            for item in items.sorted(using: KeyPathComparator(\.pageNumber)) {
                guard
                    let destinationPage = newPDF.page(at: item.pageNumber - tocPageCount + tocPageIndex - 2)
                else {
                    throw AppError.createPdfError
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

//
//  ExportSong.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// Functions to export a song to PDF
enum ExportSong {

    /// The width of the SwiftUI Views
    static let pageWidth: Double = 800
    /// The render scale for the `ImageRenderer`
    static let rendererScale: Double = 2.0

    /// Create a PDF file of the song
    /// - Parameter song: The song
    /// - Returns: The song as NSData
    @MainActor
    static func createPDF(song: Song) -> NSData? {
        if let header = renderHeader(song: song) {
            var parts: [CGImage] = []
            if let chords = renderChords(song: song) {
                parts.append(chords)
            }
            parts += renderParts(song: song)
            let pages = mergeParts(header: header, parts: parts)
            return pages2pdf(pages: pages)
        }
        return nil
    }

    /// Merge all the parts into pages
    /// - Parameters:
    ///   - header: The header of the song
    ///   - parts: The parts of the song
    /// - Returns: An array of `NSImage`
    static private func mergeParts(header: CGImage, parts: [CGImage]) -> [SWIFTImage] {

        var page = CIImage(cgImage: header)

        /// A4 aspect ratio for a page
        let pageSize = CGSize(width: page.extent.width / rendererScale, height: (page.extent.width * 1.414) / rendererScale)

        var pageHeight: Double = page.extent.size.height

        var pages: [SWIFTImage] = []

        guard
            let filter = CIFilter(name: "CIAdditionCompositing")
        else {
            return []
        }

        for part in parts {
            let append = CIImage(cgImage: part)

            let partHeight = append.extent.size.height

            if pageHeight + partHeight > (pageSize.height * rendererScale) {
                closePage()
                page = append
                pageHeight = append.extent.height
            } else {
                page = page.transformed(by: CGAffineTransform(translationX: 0, y: append.extent.height))

                filter.setDefaults()
                filter.setValue(page, forKey: "inputImage")
                filter.setValue(append, forKey: "inputBackgroundImage")

                page = filter.outputImage ?? page

                pageHeight += partHeight
            }
        }
        /// Close the last page
        closePage()
        /// Return the pages
        return pages

        /// Helper function to close a page
        func closePage() {
            let rectToDrawIn = CGRect(
                x: 0,
                y: pageSize.height - (page.extent.height / rendererScale),
                width: page.extent.width / rendererScale,
                height: page.extent.height / rendererScale
            )
#if os(macOS)
            let rep = NSCIImageRep(ciImage: page)

            let finalA4 = SWIFTImage(size: pageSize)
            finalA4.lockFocus()

            rep.draw(in: rectToDrawIn)
            finalA4.unlockFocus()

            pages.append(finalA4)
#endif
        }
    }

    /// Create a PDF from the pages
    /// - Parameter pages: The pages of the song
    /// - Returns: A PDF as `NSData`
    static private func pages2pdf(pages: [SWIFTImage]) -> NSData? {

        /// The margins for the individual page
        let margin = CGSize(width: 10, height: 14.14)
        /// The content size for PDF page, in A4 ratio
        let contentSize = CGSize(width: pages.first?.size.width ?? 0, height: pages.first?.size.height ?? 0)
        /// The box dimensions of the PDF
        var mediaBox = CGRect(x: 0, y: 0, width: contentSize.width + (margin.width * 2), height: contentSize.height + (margin.height * 2))
        /// The box dimensions of the content
        let contentBox = CGRect(x: margin.width, y: margin.height, width: contentSize.width, height: contentSize.height)

        /// Create the PDF
        let pdfData = NSMutableData()
        guard
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData),
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)
        else {
            return nil
        }
        /// Add all the pages````
        for page in pages {
            /// Convert NSImage to CGImage
            var rect = CGRect(origin: CGPoint(x: 0, y: 0), size: page.size)
#if os(macOS)
            guard
                let cgPage = page.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)
            else {
                return nil
            }
            /// Add the page
            pdfContext.beginPage(mediaBox: &mediaBox)
            pdfContext.draw(cgPage, in: contentBox)
            pdfContext.endPage()
#else
            return nil
#endif
        }
        return pdfData
    }
}

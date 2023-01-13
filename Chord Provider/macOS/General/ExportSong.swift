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

    /// Create a PDF file of the song
    /// - Parameter song: The song
    /// - Returns: The song as NSData
    @MainActor static func createPDF(song: Song) -> NSData? {
        if let header = renderHeader(song: song) {
            let parts = renderParts(song: song)
            let pages = mergeParts(header: header, parts: parts)
            return pages2pdf(pages: pages)
        }
        return nil
    }

    /// Render the header of the song
    /// - Parameter song: The song
    /// - Returns: The header as CGImage
    @MainActor private static func renderHeader(song: Song) -> CGImage? {
        let renderer = ImageRenderer(
            content:
                VStack {
                    Text(song.title ?? "Title")
                        .font(.title)
                    Text(song.artist ?? "Artist")
                        .font(.title2)
                }
                .padding()
                .frame(width: 800, alignment: .center)
                .preferredColorScheme(.light)
                .background(.white)
        )
        renderer.scale = 3.0
        return renderer.cgImage
    }

    /// Render all the parts of the song
    /// - Parameter song: The song
    /// - Returns: An array of `CGImage`
    @MainActor private static func renderParts(song: Song) -> [CGImage] {
        var parts: [CGImage] = []
        var part: CGImage?
        for section in song.sections {
            switch section.type {
            case .verse:
                part = renderPart(view: SongRenderView.VerseView(section: section, scale: 1))
            case .chorus:
                part = renderPart(view: SongRenderView.ChorusView(section: section, scale: 1))
            case .bridge:
                part = renderPart(view: SongRenderView.VerseView(section: section, scale: 1))
            case .repeatChorus:
                part = renderPart(view: SongRenderView.RepeatChorusView(section: section, scale: 1))
            case .tab:
                part = renderPart(view: SongRenderView.TabView(section: section, scale: 1))
            case .grid:
                part = renderPart(view: SongRenderView.GridView(section: section, scale: 1))
            case .comment:
                part = renderPart(view: SongRenderView.CommentView(section: section, scale: 1))
            default:
                part = renderPart(view: SongRenderView.PlainView(section: section, scale: 1))
            }
            if let part {
                parts.append(part)
            }
        }
        return parts

        /// Helper function to render a part
        /// - Parameter view: The SwiftUI View to render
        /// - Returns: A `CGImage` of the View
        func renderPart<T: View>(view: T) -> CGImage? {
            let renderer = ImageRenderer(
                content:
                    VStack {
                        Grid(alignment: .topTrailing, verticalSpacing: 20) {
                            view
                        }
                        .padding()
                    }
                    .frame(width: 800, alignment: .leading)
                    .background(.white)
                    .font(.system(size: 14))
            )
            renderer.scale = 3.0
            return renderer.cgImage
        }
    }

    /// Merge all the parts into pages
    /// - Parameters:
    ///   - header: The header of the song
    ///   - parts: The parts of the song
    /// - Returns: An array of `NSImage`
    static private func mergeParts(header: CGImage, parts: [CGImage]) -> [NSImage] {

        var page = CIImage(cgImage: header)

        /// A4 aspect ratio for a page
        let pageSize = NSSize(width: page.extent.width / 3, height: (page.extent.width * 1.414) / 3)

        var pageHeight: Double = page.extent.size.height

        var pages: [NSImage] = []

        let filter = CIFilter(name: "CIAdditionCompositing")!

        for part in parts {
            let append = CIImage(cgImage: part)

            let partHeight = append.extent.size.height

            if pageHeight + partHeight > (pageSize.height * 3) {
                closePage()
                page = append
                pageHeight = append.extent.height
            } else {
                page = page.transformed(by: CGAffineTransform(translationX: 0, y: append.extent.height))

                filter.setDefaults()
                filter.setValue(page, forKey: "inputImage")
                filter.setValue(append, forKey: "inputBackgroundImage")

                page = filter.outputImage!

                pageHeight += partHeight
            }
        }
        /// Close the last page
        closePage()
        /// Return the pages
        return pages

        /// Helper function to close a page
        func closePage() {
            let rectToDrawIn = CGRect(x: 0,
                                      y: pageSize.height - (page.extent.height / 3),
                                      width: page.extent.width / 3,
                                      height: page.extent.height / 3
            )
            let rep = NSCIImageRep(ciImage: page)

            let finalA4 = NSImage(size: pageSize)
            finalA4.lockFocus()

            rep.draw(in: rectToDrawIn)
            finalA4.unlockFocus()

            pages.append(finalA4)
        }
    }

    /// Create a PDF from the pages
    /// - Parameter pages: The pages of the song
    /// - Returns: A PDF as `NSData`
    static private func pages2pdf(pages: [NSImage]) -> NSData? {

        /// The margins for the individual page
        let margin = NSSize(width: 10, height: 14.14)
        /// The content size for PDF page, in A4 ratio
        let contentSize = NSSize(width: pages.first?.size.width ?? 0, height: pages.first?.size.height ?? 0)
        /// The box dimensions of the PDF
        var mediaBox = NSRect(x: 0, y: 0, width: contentSize.width + (margin.width * 2), height: contentSize.height + (margin.height * 2))
        /// The box dimensions of the content
        let contentBox = NSRect(x: margin.width, y: margin.height, width: contentSize.width, height: contentSize.height)

        /// Create the PDF
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        /// Add all the pages````
        for page in pages {
            /// Convert NSImage to CGImage
            var rect = NSRect(origin: CGPoint(x: 0, y: 0), size: page.size)
            let cgPage = page.cgImage(forProposedRect: &rect, context: NSGraphicsContext.current, hints: nil)!
            /// Add the page
            pdfContext.beginPage(mediaBox: &mediaBox)
            pdfContext.draw(cgPage, in: contentBox)
            pdfContext.endPage()
        }
        return pdfData
    }
}

/// Define the exported  'ChordProviderDocument'
struct ChordProviderDocument: FileDocument {
    /// The type of image to export
    static var readableContentTypes: [UTType] { [.pdf] }
    /// The image to export
    var image: NSData
    /// Init the struct
    init(image: NSData?) {
        self.image = image ?? NSData()
    }
    /// Black magic
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.image = NSData(data: data)
    }
    /// Save the exported image
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: image as Data)
    }
}

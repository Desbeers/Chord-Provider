//
//  Export.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import UniformTypeIdentifiers

/// SwiftUI `Button` to export a song
struct ExportButtonView: View {
    /// The ``Song``
    let song: Song
    /// Present an export dialog
    @State private var exportFile = false
    /// The song as image
    @State private var image: NSData?
    /// The body of the `View`
    var body: some View {
        Button(action: {
            renderSong()
        }, label: {
            Label("Export song", systemImage: "square.and.arrow.up")
        })
        .fileExporter(isPresented: $exportFile,
                      document: ImageDocument(image: image),
                      contentType: .pdf, defaultFilename: "\(song.artist ?? "Artist") - \(song.title ?? "Title")",
                      onCompletion: { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        })
    }

    /// Render the song as a PDF
    @MainActor private func renderSong() {
        let renderer = ImageRenderer(content: SongExportView(song: song))
        renderer.scale = 3.0
        image = createPDF(image: renderer, paged: true)
        exportFile = true
    }
}

/// Create a PDF from an image
/// - Parameters:
///   - image: Result of the SwiftUI `ImageRenderer`
///   - paged: Bool if the PDF should be multi-page or not
/// - Returns: The PDF as `NSData`
@MainActor func createPDF<T: View>(image: ImageRenderer<T>, paged: Bool = true) -> NSData? {

    /// one long page render
    var singlePage: NSData? {
        if let nsImage = image.nsImage, let cgImage = image.cgImage {
            let pdfData = NSMutableData()
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
            var mediaBox = NSRect.init(x: 0, y: 0, width: nsImage.size.width, height: nsImage.size.height)
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
            pdfContext.beginPage(mediaBox: &mediaBox)
            pdfContext.draw(cgImage, in: mediaBox)
            pdfContext.endPage()
            return pdfData
        }
        return nil
    }

    /// multy page render
    var multiPage: NSData? {

        if let nsImage = image.nsImage, let cgImage = image.cgImage {
            /// The margins for the individual page
            let margin = NSSize(width: 10, height: 14.14)
            /// The PDF pages
            var pages: [CGImage] = []
            /// The content size for PDF page, in A4 ratio
            let contentSize = NSSize(width: nsImage.size.width, height: nsImage.size.width * 1.414)
            /// The box dimensions of the PDF
            var mediaBox = NSRect(x: 0, y: 0, width: contentSize.width + (margin.width * 2), height: contentSize.height + (margin.height * 2))
            /// The box dimensions of the content
            let contentBox = NSRect(x: margin.width, y: margin.height, width: contentSize.width, height: contentSize.height)
            /// Calculate the total amount of pages
            let totalPages = Int(ceil(nsImage.size.height / (nsImage.size.width * 1.414)))
            /// Cut the image in 'page pieces'
            for page in 0..<totalPages {
                /// Calculate the cropBox
                let cropBox = CGRect(x: 0,
                                     y: contentSize.height * CGFloat(page) * image.scale,
                                     width: contentSize.width * image.scale,
                                     height: contentSize.height * image.scale
                )
                /// Cropping is optional
                if let part = cgImage.cropping(to: cropBox) {
                    pages.append(part)
                }
            }
            /// Create the PDF
            let pdfData = NSMutableData()
            let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
            let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
            /// Add all the pages````
            for page in pages {
                pdfContext.beginPage(mediaBox: &mediaBox)
                /// The last page might be too small
                if page.height < Int(contentSize.height * image.scale) {
                    let newHeight = (Double(page.height) / image.scale)
                    let newContentBox = NSRect(x: margin.width, y: mediaBox.height - newHeight - margin.height, width: contentSize.width, height: newHeight)
                    pdfContext.draw(page, in: newContentBox)
                } else {
                    pdfContext.draw(page, in: contentBox)
                }
                pdfContext.endPage()
            }
            return pdfData
        }
        return nil
    }

    switch paged {

    case true:
        return multiPage
    case false:
        return singlePage
    }
}

/// SwiftUI `View` of the song rendered by the SwiftUI `ImageRenderer`
struct SongExportView: View {
    /// The ``Song``
    let song: Song
    /// The body of the `View`
    var body: some View {
        VStack {
            Text(song.title ?? "Title")
                .font(.title)
            Text(song.artist ?? "Artist")
                .font(.title2)
            SongRenderView(song: song, scale: 1)
        }
        .padding()
        .frame(width: 800, alignment: .center)
        .preferredColorScheme(.light)
        .background(.white)
    }
}

/// Define the exported  'ImageDocument'
struct ImageDocument: FileDocument {
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

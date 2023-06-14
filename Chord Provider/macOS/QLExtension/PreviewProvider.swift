//
//  PreviewProvider.swift
//  Chord Provider - QLExtension
//
//  © 2023 Nick Berendsen
//

import Cocoa
import Quartz
import SwiftUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    @MainActor func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.pdf
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate: QLPreviewReply) in
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(text: fileContents, transpose: 0)
            let renderer = ImageRenderer(content: SongExportView(song: song))
            renderer.scale = 3.0
            guard let image = self.createPDF(image: renderer) else {
                fatalError()
            }
            replyToUpdate.title = "\(song.artist ?? "Artist") - \(song.title ?? "Title")"
            replyToUpdate.stringEncoding = .utf8
            return image as Data
        }
        return reply
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
                Song.Render(song: song, scale: 1)
            }
            .padding()
            .frame(width: 800, alignment: .center)
            .preferredColorScheme(.light)
            .background(.white)
            .accentColor(Color("AccentColor"))
        }
    }

    /// Create a PDF from an image
    /// - Parameters:
    ///   - image: Result of the SwiftUI `ImageRenderer`
    /// - Returns: The PDF as `NSData`
    @MainActor func createPDF<T: View>(image: ImageRenderer<T>) -> NSData? {
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
}

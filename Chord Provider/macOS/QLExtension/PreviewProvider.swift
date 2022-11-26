//
//  PreviewProvider.swift
//  Chord Provider - QLExtension
//
//  © 2022 Nick Berendsen
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
            let song = ChordPro.parse(text: fileContents, transponse: 0, file: request.fileURL)
            let renderer = ImageRenderer(content: SongExportView(song: song))
            renderer.scale = 3.0
            guard let image = createPDF(image: renderer, paged: false) else {
                fatalError()
            }
            replyToUpdate.title = "\(song.artist ?? "Artist") - \(song.title ?? "Title")"
            replyToUpdate.stringEncoding = .utf8
            return image as Data
        }
        return reply
    }
}

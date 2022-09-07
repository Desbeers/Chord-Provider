//
//  PreviewProvider.swift
//  Chord Provider - QLExtension
//
//  © 2022 Nick Berendsen
//

import Cocoa
import Quartz

class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.html
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate: QLPreviewReply) in
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(text: fileContents, file: request.fileURL)
            guard let data = song.html?.data(using: .utf8) else {
                fatalError()
            }
            replyToUpdate.stringEncoding = .utf8
            return data
        }
        return reply
    }
}

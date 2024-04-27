//
//  PreviewProvider.swift
//  Chord Provider - QLpreview
//
//  © 2023 Nick Berendsen
//

import Cocoa
import Quartz
import SwiftUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.pdf
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate: QLPreviewReply) in
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(text: fileContents, transpose: 0, instrument: .guitarStandardETuning)
            let data = try SongExport.export(song: song, options: .init()).pdf
            replyToUpdate.title = "\(song.artist ?? "Artist") - \(song.title ?? "Title")"
            replyToUpdate.stringEncoding = .utf8
            return data
        }
        return reply
    }
}

//
//  PreviewProvider.swift
//  Chord Provider - QLpreview
//
//  © 2024 Nick Berendsen
//

import Cocoa
import Quartz

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.pdf
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate: QLPreviewReply) in
            let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
            let song = ChordPro.parse(
                id: UUID(),
                text: fileContents,
                transpose: 0,
                instrument: .guitarStandardETuning,
                fileURL: request.fileURL
            )
            let data = try SongExport.export(
                song: song,
                chordDisplayOptions: .init()
            ).pdf
            replyToUpdate.title = "\(song.metaData.artist) - \(song.metaData.title)"
            replyToUpdate.stringEncoding = .utf8
            return data
        }
        return reply
    }
}

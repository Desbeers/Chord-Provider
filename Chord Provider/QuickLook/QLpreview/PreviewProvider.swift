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
            let song = ChordProParser.parse(
                id: UUID(),
                text: fileContents,
                transpose: 0,
                settings: AppSettings(),
                fileURL: request.fileURL
            )
            let data = try SongExport.export(
                song: song
            ).pdf
            replyToUpdate.title = "\(song.metaData.artist) - \(song.metaData.title)"
            replyToUpdate.stringEncoding = .utf8
            return data
        }
        return reply
    }
}

protocol ChordProDirective {}

struct AppSettings {
    /// Simple substitute for the real AppSettings
    var diagram = DiagramDisplayOptions()
    var song = SongDisplayOptions()
}

struct ChordProEditor {
    /// Simple substitute for the real ChordProEditor
}

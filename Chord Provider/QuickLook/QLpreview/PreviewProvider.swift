//
//  PreviewProvider.swift
//  Chord Provider - QLpreview
//
//  © 2025 Nick Berendsen
//

import Cocoa
import Quartz

class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.pdf
        let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
        let song = await ChordProParser.parse(
            id: UUID(),
            text: fileContents,
            transpose: 0,
            settings: AppSettings(),
            fileURL: request.fileURL
        )
        let songData = try await SongExport.export(
            song: song,
            appSettings: AppSettings()
        ).pdf

        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { (replyToUpdate: QLPreviewReply) in

            let data = songData

            replyToUpdate.title = "\(song.metadata.artist) - \(song.metadata.title)"
            replyToUpdate.stringEncoding = .utf8
            return data
        }
        return reply
    }
}

// MARK: Substitutes

struct AppSettings {
    /// Simple substitute for the real AppSettings
    var application = Application()
    var song = Song()
}

extension AppSettings {

    /// Load the application settings
    /// - Parameter id: The ID of the settings
    /// - Returns: The default ``AppSettings``
    static func load(id: AppSettings.AppWindowID) -> AppSettings {
        AppSettings()
    }
}

extension SongExport {

    ///  Sandbox restriction, sandbox extension cannot load local external images
    static func loadImage(source: String, fileURL: URL?) async -> NSImage? {
        nil
    }
}

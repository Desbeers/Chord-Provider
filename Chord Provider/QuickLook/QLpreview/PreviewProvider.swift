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

        var settings = AppSettings()

        var inDarkMode: Bool {
            let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
            return mode == "Dark"
        }

        switch inDarkMode {

        case true:
            settings.pdf = AppSettings.PDF.Preset.dark.presets(settings: settings.pdf)
        case false:
            settings.pdf = AppSettings.PDF.Preset.light.presets(settings: settings.pdf)
        }

        let contentType = UTType.pdf
        let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
        let song = await ChordProParser.parse(
            id: UUID(),
            text: fileContents,
            transpose: 0,
            settings: settings,
            fileURL: request.fileURL
        )
        let songData = try await SongExport.export(
            song: song,
            appSettings: settings
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
    var pdf = PDF()
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

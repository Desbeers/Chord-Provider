//
//  PreviewProvider.swift
//  Chord Provider - QLpreview
//
//  © 2025 Nick Berendsen
//

import Cocoa
import Quartz

/// Create a PDF preview for a **ChordPro** file
class PreviewProvider: QLPreviewProvider, QLPreviewingController {

    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {

        var settings = AppSettings()

        var inDarkMode: Bool {
            let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
            return mode == "Dark"
        }

        switch inDarkMode {

        case true:
            settings.style = AppSettings.Style.ColorPreset.dark.presets(style: settings.style)
        case false:
            settings.style = AppSettings.Style.ColorPreset.light.presets(style: settings.style)
        }

        let contentType = UTType.pdf
        let fileContents = try String(contentsOf: request.fileURL, encoding: .utf8)
        var song = await ChordProParser.parse(song: Song(id: UUID(), content: fileContents))
        /// Pass the application settings to the song
        song.settings = settings
        let songData = try await SongExport.export(
            song: song
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

/// Simple substitute for the real AppSettings
struct AppSettings: Equatable, Codable {
    var application = Application()
    var shared = Shared()
    var display = Display()
    var diagram = Diagram()
    var style = Style()
    var pdf = AppSettings.PDF()
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

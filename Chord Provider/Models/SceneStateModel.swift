//
//  SceneStateModel.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable scene state for **Chord Provider**
@MainActor @Observable final class SceneStateModel {
    /// The optional file URL
    var file: URL?
    /// The optional template URL
    /// - Used to get custom configs next to the template URL (official **ChordPro** support)
    var template: URL?
    /// The current ``Song``
    var song: Song
    /// PDF preview related stuff
    var preview = PreviewState()
    /// The internals of the **Chord Provider** editor
    var editorInternals = ChordProEditor.Internals()
    /// The settings for the scene
    var settings: AppSettings
    /// The status of the View
    var status: Status = .loading
    /// Show an `Alert` if we have an error
    var errorAlert: AlertMessage?

    // MARK: Song View options

    /// Bool to show the editor or not
    var showEditor: Bool = false
    /// Bool that some animation is ongoing
    /// - Note: Used to hide the ``SongView`` during animation because of performance
    var isAnimating: Bool = false

    // MARK: Editor stuff

    /// All the values of a ``ChordDefinition``
    /// - Note: Used for editing a chord
    var definition: ChordDefinition
    /// Bool to show the `clean` confirmation dialog
    var cleanConfirmation = false

    // MARK: Export Stuff

    /// The temporary directory URL for processing files
    /// - Note: In its own directory so easier to debug
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("ChordProviderTMP", isDirectory: true)
    /// The URL of the export PDF
    var exportURL: URL {
        let fileName = "\(song.metadata.artist) - \(song.metadata.title)"
        /// Create an export URL
        return temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .pdf)
    }

    /// Export the song to a PDF
    func exportSongToPDF() async throws -> Data {
        let settings = AppSettings.load(id: .mainView)
        switch settings.chordPro.useChordProCLI {
        case false:
            /// Default renderer
            do {
                let appSettings = AppSettings.load(id: .mainView)
                let export = try await SongExport.export(
                    song: song, appSettings: appSettings
                )
                try export.pdf.write(to: exportURL)
                return export.pdf
            } catch {
                Logger.application.error("PDF error: \(error.localizedDescription, privacy: .public)")
                throw error
            }
        case true:
            /// ChordPro CLI renderer
            do {
                let export = try await Terminal.exportPDF(text: song.content, settings: AppSettings.load(id: .mainView), sceneState: self)
                return export.data
            } catch {
                Logger.application.error("ChordPro CLI error: \(error.localizedDescription, privacy: .public)")
                throw error
            }
        }
    }

    /// Get the optional media stored next to a song file
    func getMedia() {
        if let fileURL = song.metadata.fileURL {
            var mediaURL = fileURL.deletingPathExtension().appendingPathExtension("m4a")
            if mediaURL.exist() {
                song.metadata.audioURL = mediaURL
            }
            mediaURL = fileURL.deletingPathExtension().appendingPathExtension("mp3")
            if mediaURL.exist() {
                song.metadata.audioURL = mediaURL
            }
            mediaURL = fileURL.deletingPathExtension().appendingPathExtension("mp4")
            if mediaURL.exist() {
                song.metadata.videoURL = mediaURL
            }
        }
    }

    // MARK: ChordPro CLI integration

    /// The URL of the source file
    var sourceURL: URL {
        let fileName = "\(song.metadata.artist) - \(song.metadata.title)"
        /// Create an export URL
        return temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .chordProSong)
    }

    /// The optional local configuration (a config named `chordpro.json` next to a song)
    var localSystemConfigURL: URL? {
        if let file {
            let systemConfig = file.deletingLastPathComponent().appendingPathComponent("chordpro", conformingTo: .json)
            if FileManager.default.fileExists(atPath: systemConfig.path) {
                return systemConfig
            }
            return nil
        }
        return nil
    }

    /// The optional local configuration (a config with the same base-name next to a song)
    var localSongConfigURL: URL? {
        if let file {
            let localConfig = file.deletingPathExtension().appendingPathExtension("json")
            let haveConfig = FileManager.default.fileExists(atPath: localConfig.path)
            return haveConfig ? localConfig : nil
        }
        if let template {
            let templateConfig = template.deletingPathExtension().appendingPathExtension("json")
            let haveConfig = FileManager.default.fileExists(atPath: templateConfig.path)
            return haveConfig ? templateConfig : nil
        }
        return nil
    }

    // MARK: Init

    /// Init the class
    init(id: AppSettings.AppWindowID = .mainView) {
        settings = AppSettings.load(id: id)
        // swiftlint:disable:next force_unwrapping
        self.definition = ChordDefinition(name: "C", instrument: .guitar)!
        /// Create the temp directory
        try? FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true)
        /// Init the song with an unique ID
        self.song = Song(id: UUID(), content: "")
    }
}

extension SceneStateModel {

    /// The status of a Scene View
    enum Status {
        /// Loading a View
        case loading
        /// The View is ready
        case ready
        /// The View has an error
        case error
    }
}

extension FocusedValues {

    /// The value of the scene state
    @Entry var sceneState: SceneStateModel?
}

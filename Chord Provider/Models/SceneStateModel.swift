//
//  SceneStateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable scene state for **Chord Provider**
@Observable final class SceneStateModel {
    /// The optional file location
    var file: URL?
    /// The raw content of the document
    var content: String = ""
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
    func exportSongToPDF() async -> (data: Data, url: URL)? {
        let settings = AppSettings.load(id: .mainView)
        switch settings.chordPro.useChordProCLI {
        case false:
            /// Default renderer
            do {
                let export = try SongExport.export(
                    song: song
                )
                try export.pdf.write(to: exportURL)
                return (export.pdf, exportURL)
            } catch {
                Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
                errorAlert = error.alert()
                return nil
            }
        case true:
            /// ChordPro CLI renderer
            do {
                let export = try await Terminal.exportPDF(text: content, settings: AppSettings.load(id: .mainView), sceneState: self)
                return (export.data, self.exportURL)
            } catch {
                Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
                errorAlert = error.alert()
                return nil
            }
        }
    }

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

    // MARK: ChordPro integration

    /// The log messages
    var logMessages: [LogMessage.Item] = [.init()]
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
        return nil
    }

    // MARK: Init

    /// Init the class
    init(id: AppStateModel.AppStateID) {
        settings = AppSettings.load(id: id)
        // swiftlint:disable:next force_unwrapping
        self.definition = ChordDefinition(name: "C", instrument: .guitar)!
        /// Create the temp directory
        try? FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true)
        /// Init the song with an unique ID
        self.song = Song(id: UUID())
    }
}

extension SceneStateModel {

    enum Status {
        case loading
        case ready
        case error
    }
}

/// The `FocusedValueKey` for the scene state
struct SceneFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = SceneStateModel
}

extension FocusedValues {
    /// The value of the scene state key
    var sceneState: SceneFocusedValueKey.Value? {
        get {
            self[SceneFocusedValueKey.self]
        }
        set {
            self[SceneFocusedValueKey.self] = newValue
        }
    }
}

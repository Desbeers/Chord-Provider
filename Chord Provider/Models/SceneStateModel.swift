//
//  SceneStateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable scene state for **Chord Provider**
@MainActor @Observable final class SceneStateModel {
    /// The current ``Song``
    var song = Song()
    /// PDF preview related stuff
    var preview = PreviewState()
    /// The internals of the **Chord Provider** editor
    var editorInternals = ChordProEditor.Internals()

    var settings: AppSettings

    // MARK: Song View options

    /// Bool to show the editor or not
    var showEditor: Bool = false

    // MARK: Editor stuff

    /// All the values of a ``ChordDefinition``
    /// - Note: Used for editing a chord
    var definition: ChordDefinition

    // MARK: Export Stuff

    /// The temporary directory URL for processing files
    /// - Note: In its own directory so easier to debug
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("ChordProviderTMP", isDirectory: true)
    /// The URL of the export PDF
    var exportURL: URL {
        let fileName = "\(song.metaData.artist) - \(song.metaData.title)"
        /// Create an export URL
        return temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .pdf)
    }

    /// Export the song to a PDF
    func exportSongToPDF() -> (data: Data, url: URL)? {
        do {
            let export = try SongExport.export(
                song: song
            )
            try export.pdf.write(to: exportURL)
            return (export.pdf, exportURL)
        } catch {
            Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    func getMedia() {
        if let fileURL = song.metaData.fileURL {
            var mediaURL = fileURL.deletingPathExtension().appendingPathExtension("m4a")
            if mediaURL.exist() {
                song.metaData.audioURL = mediaURL
            }
            mediaURL = fileURL.deletingPathExtension().appendingPathExtension("mp4")
            if mediaURL.exist() {
                song.metaData.videoURL = mediaURL
            }
        }
    }

    // MARK: Init

    /// Init the class
    init(id: AppStateModel.AppStateID) {
        settings = AppSettings.load(id: id)
        // swiftlint:disable:next force_unwrapping
        self.definition = ChordDefinition(name: "C", instrument: .guitar)!
        /// Create the temp directory
        try? FileManager.default.createDirectory(at: temporaryDirectoryURL, withIntermediateDirectories: true)
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

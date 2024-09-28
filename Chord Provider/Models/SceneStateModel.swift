//
//  SceneStateModel.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// The observable scene state for Chord Provider
@Observable final class SceneStateModel {
    /// The current ``Song``
    var song = Song()
    /// The optional file location
    var file: URL?
    /// PDF preview related stuff
    var preview = PreviewState()
    /// The internals of the **Chord Provider** editor
    var editorInternals = ChordProEditor.Internals()

    // MARK: Song View options

    /// Song display options
    var songDisplayOptions: Song.DisplayOptions
    /// Chord Display Options
    var chordDisplayOptions: ChordDisplayOptions
    /// The current magnification scale
    var currentScale: Double = 1.0
    /// Bool to show the editor or not
    var showEditor: Bool = false

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
                song: song,
                chordDisplayOptions: chordDisplayOptions.displayOptions
            )
            try export.pdf.write(to: exportURL)
            return (export.pdf, exportURL)
        } catch {
            Logger.application.error("Error creating export: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }

    // MARK: Init

    /// Init the class
    init() {
        /// Get the default settings as is used last time
        let appSettings = AppSettings.load(id: "Main")
        self.songDisplayOptions = appSettings.songDisplayOptions
        self.chordDisplayOptions = ChordDisplayOptions(defaults: appSettings.chordDisplayOptions)
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

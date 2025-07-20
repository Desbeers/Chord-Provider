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
    /// The current ``Song``
    var song: Song
    /// PDF preview related stuff
    var preview = Preview()
    /// The internals of the **Chord Provider** editor
    var editorInternals = ChordProEditor.Internals()
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

    // MARK: Scaling

    /// The total width of the window
    var windowWidth: Double = 0

    /// The offset from centre for the text editor
    var editorOffset: Double = 0

    var editorWidth: Double {
        (windowWidth / 2) + editorOffset
    }

    // MARK: Export Stuff

    /// Export the song to a PDF
    func exportSongToPDF() async throws -> Data {
        switch song.settings.chordProCLI.useChordProCLI {
        case false:
            /// Default renderer
            do {
                let export = try await SongExport.export(
                    song: song
                )
                try export.pdf.write(to: song.metadata.exportURL)
                return export.pdf
            } catch {
                Logger.application.error("PDF error: \(error.localizedDescription, privacy: .public)")
                throw error
            }
        case true:
            /// ChordPro CLI renderer
            do {
                let export = try await ChordProCLI.exportPDF(
                    song: self.song
                )
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
            if mediaURL.exist {
                song.metadata.audioURL = mediaURL
            }
            mediaURL = fileURL.deletingPathExtension().appendingPathExtension("mp3")
            if mediaURL.exist {
                song.metadata.audioURL = mediaURL
            }
            mediaURL = fileURL.deletingPathExtension().appendingPathExtension("mp4")
            if mediaURL.exist {
                song.metadata.videoURL = mediaURL
            }
        }
    }

    // MARK: Init

    /// Init the class
    init(id: AppSettings.AppWindowID = .mainView) {
        // swiftlint:disable:next force_unwrapping
        self.definition = ChordDefinition(name: "C", instrument: .guitar)!
        /// Init the song with an unique ID
        self.song = Song(id: UUID(), content: "")
        /// Add the last used settings
        let settings = AppSettings.load(id: id)
        self.song.settings = settings
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

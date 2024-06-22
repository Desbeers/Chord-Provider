//
//  SceneState.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

/// The observable scene state for Chord Provider
@Observable final class SceneState {
    /// The current ``Song``
    var song = Song()
    /// The selection in the editor
    var selection: NSRange = .init(location: 0, length: 0)
    /// Bool to show the `print` dialog (macOS)
    var showPrintDialog: Bool = false
    /// The optional file location
    var file: URL?
    /// Show settings (not for macOS)
    var showSettings: Bool = false
    /// Present template sheet
    var presentTemplate: Bool = false
    /// The optional URL for a PDF quicklook
    var quicklookURL: URL?

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

    var exportURL: URL {
        let fileName = "\(song.metaData.artist) - \(song.metaData.title)"
        /// Create URLs
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        /// Create an export URL
        return temporaryDirectoryURL.appendingPathComponent(fileName, conformingTo: .pdf)
    }

    // MARK: Init

    init() {
        /// Get the default settings as is used last time
        let appSettings = AppSettings.load(id: "Main")
        self.songDisplayOptions = appSettings.songDisplayOptions
        self.chordDisplayOptions = ChordDisplayOptions(defaults: appSettings.chordDisplayOptions)
    }
}


/// The `FocusedValueKey` for the scene state
struct SceneFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = SceneState
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

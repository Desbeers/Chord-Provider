//
//  AppState.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

/// The observable application state for **Chord Provider**
@Observable final class AppStateModel {
    /// The shared instance of the class
    nonisolated(unsafe) static let shared = AppStateModel(id: .mainView)
    /// The list with recent files
    var recentFiles: [URL] = []
    /// The standard content for a new document
    var standardDocumentContent: String
    /// The actual content for a new song
    /// - Note: This will be different than the standard when opened from the ``WelcomeView``
    var newDocumentContent: String

    /// The ID of the app state
    var id: AppStateID
    /// The application settings
    var settings: AppSettings {
        didSet {
            try? AppSettings.save(id: id, settings: settings)
        }
    }

    var imageCache: NSCache<NSURL, NSImage>?

    func setImageCache(image: NSImage, key: URL) {
        imageCache?.setObject(image, forKey: key as NSURL)
    }

    func getImageFromCache(from key: URL) -> NSImage? {
        imageCache?.object(forKey: key as NSURL) as? NSImage
    }

    var media = MediaPlayerView.Item()

    /// Init the class; get application settings
    init(id: AppStateID) {
        self.id = id
        /// Get the application settings from the cache
        let settings = AppSettings.load(id: id)
        self.settings = settings
        /// Set the content of a new song
        let content = ChordProDocument.getSongTemplateContent(settings: settings)
        self.standardDocumentContent = content
        self.newDocumentContent = content
    }
}

extension AppStateModel {

    /// Add the user settings as arguments to **ChordPro** for the Terminal action
    /// - Parameter settings: The ``AppSettings``
    /// - Returns: An array with arguments
    static func getUserSettings(settings: AppSettings) -> [String] {
        /// Start with an empty array
        var arguments: [String] = []
        /// Optional show only the lyrics
        if settings.song.display.lyricsOnly {
            arguments.append("--lyrics-only")
        }
        /// Return the basic settings
        return arguments
    }
}

extension AppStateModel {

    /// The ID of the app state
    /// - Note: Used to load and save the settings in the cache
    enum AppStateID: String {
        case mainView
        case exportFolderView
        case chordsDatabaseView
    }
}

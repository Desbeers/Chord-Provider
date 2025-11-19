//
//  AppState.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import Adwaita

/// The state of **Chord Provider**
struct AppState {
    init() {
        if var settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            self.settings = settings
        } else {
            print("No settings found, creating new one")
        }
        /// Open an optional song URL
        if let fileURL = CommandLine.arguments[safe: 1] {
            let url = URL(filePath: fileURL)
            //self.openSong(fileURL: url)
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                self.scene.source = content
                self.scene.originalSource = content
                self.settings.core.fileURL = url
                /// Append to recent
                self.settings.app.addRecentSong(fileURL: url)
                /// Save it
                try? SettingsCache.set(id: "ChordProviderGnome", object: self.settings)
            }
        }
        if scene.source.isEmpty {
            settings.editor.showEditor = false
            scene.showWelcome = true
        }
    }

    var settings = AppSettings() {
        didSet {
            print("Saving settings")
//            print("---")
//            dump(oldValue.editor)
//            print("---")
//            dump(settings.editor)
            try? SettingsCache.set(id: "ChordProviderGnome", object: self.settings)
        }
    }
    var scene = Scene()

    /// The subtitle for the scene
    var subtitle: String {
        "\(settings.core.fileURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(scene.dirty ? " - edited" : "")"
    }
}

extension AppState {
    
    /// Open a sample song from the Bundle
    /// - Parameters:
    ///   - sample: The sample song
    ///   - showEditor: Bool to show the editor
    ///   - url: Bool if the URL should be added
    mutating func openSample(_ sample: String, showEditor: Bool = true, url: Bool = false) {
        if
            let sampleSong = Bundle.module.url(forResource: "Samples/Songs/\(sample)", withExtension: "chordpro"),
            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
            openSong(content: content, showEditor: showEditor, url: url ? sampleSong : nil)
        } else {
            print("Error loading sample song")
        }
    }

    /// Open a song from an URL
    mutating func openSong(fileURL: URL) {
        do {
            let content = try SongFileUtils.getSongContent(fileURL: fileURL)
            self.scene.source = content
            self.scene.originalSource = content
            self.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
            self.settings.core.fileURL = fileURL
            self.scene.showWelcome = false
            self.settings.app.addRecentSong(fileURL: fileURL)
        } catch {
            self.scene.toastMessage = "Could not open the song"
        }
    }

    /// Open a song with its content as string
    /// - Parameter content: The content of the song
    mutating func openSong(content: String, showEditor: Bool = true, url: URL? = nil) {
        self.scene.source = content
        self.scene.originalSource = content
        self.settings.editor.showEditor = showEditor
        if let url {
            self.settings.core.templateURL = url
        }
        self.scene.showWelcome = false
    }

    mutating func saveSong() {
        if let fileURL = self.settings.core.fileURL {
            try? self.scene.source.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the content as  saved
            self.scene.originalSource = self.scene.source
            /// Add it to the recent songs list
            self.settings.app.addRecentSong(fileURL: fileURL)
        } else {
            self.scene.saveSongAs.signal()
        }
    }

    mutating func closeWindow(window: AdwaitaWindow) {
        if self.scene.dirty {
            self.scene.saveDoneAction = .closeWindow
            self.scene.showDirtyClose = true
        } else {
            self.scene.originalSource = self.scene.source
            window.close()
        }
    }

    mutating func showWelcomeScreen() {
        print("Show Welcome Screen")
        self.scene.source = ""
        self.scene.originalSource = ""
        self.settings.core.fileURL = nil
        self.settings.editor.showEditor = false
        self.scene.showWelcome = true
    }
}

extension AppState {

    enum SaveDoneAction {
        case closeWindow
        case showWelcomeScreen
        case noAction
    }
}

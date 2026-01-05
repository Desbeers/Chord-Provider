//
//  AppState.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore
import SourceView
import Adwaita

/// The state of **Chord Provider**
struct AppState {
    init() {
        if let settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            self.settings = settings
        } else {
            print("No settings found, creating new one")
        }

        if let recentSongs = try? SettingsCache.get(id: "ChordProviderGnome-recent", struct: [AppState.RecentSong].self) {
            self.recentSongs = recentSongs
        }
        /// Open an optional song URL
        if let fileURL = CommandLine.arguments[safe: 1] {
            let url = URL(filePath: fileURL)
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                self.editor.song.content = content
                self.scene.originalSource = content
                self.editor.song.settings.fileURL = url
            }
        }
        if editor.song.content.isEmpty {
            settings.editor.showEditor = false
            scene.showWelcome = true
        }
    }

    var settings = AppSettings() {
        didSet {
            print("Saving settings")
            try? SettingsCache.set(id: "ChordProviderGnome", object: self.settings)
        }
    }

    var scene = Scene()

    private(set) var recentSongs: [RecentSong] = [] {
        didSet {
            print("Saving recent songs")
            try? SettingsCache.set(id: "ChordProviderGnome-recent", object: self.recentSongs)
        }
    }

    /// The editor bridge
    var editor = SourceViewBridge(song: Song(id: UUID(), content: ""))

    /// The subtitle for the scene
    var subtitle: String {
        "\(editor.song.settings.fileURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(dirty ? " - edited" : "")"
    }
}

extension AppState {

    /// Add a recent song
    /// - Parameter song: The parsed song
    mutating func addRecentSong(song: Song) {
        if let fileURL = song.settings.fileURL, !self.dirty {
            var recentSongs = self.recentSongs
            /// Keep only relevant information
            var recent = Song(id: UUID())
            recent.metadata.title = song.metadata.title
            recent.metadata.artist = song.metadata.artist
            recent.metadata.tags = song.metadata.tags
            recentSongs.append(
                RecentSong(
                    url: fileURL,
                    song: recent,
                    lastOpened: Date.now,
                    settings: self.editor.song.settings
                )
            )
            /// Update the list
            self.recentSongs = Array(
                recentSongs
                    .sorted(using: KeyPathComparator(\.lastOpened, order: .reverse))
                    .uniqued(by: \.id)
                    .prefix(20)
            )
        }
    }

    /// Clear recent songs list
    mutating func clearRecentSongs() {
        self.recentSongs = []
    }

    /// Get recent songs
    func getRecentSongs() -> [RecentSong] {
        var recent: [RecentSong] = []
        for song in self.recentSongs where FileManager.default.fileExists(atPath: song.url.path) {
            recent.append(song)
        }
        /// Return to the `View`
        return recent
    }

    /// Bool if the source is modified
    /// - Note: Comparing the source with the original source
    var dirty: Bool {
        editor.song.content != scene.originalSource
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
            /// Reset transpose
            self.editor.song.settings.transpose = 0
            self.editor.song.content = content
            self.scene.originalSource = content
            self.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
            self.scene.showWelcome = false
            self.editor.song.settings.fileURL = fileURL
        } catch {
            self.scene.toastMessage = "Could not open the song"
        }
    }

    /// Open a song with its content as string
    /// - Parameter content: The content of the song
    mutating func openSong(content: String, showEditor: Bool = true, url: URL? = nil) {
        /// Reset transpose
        self.editor.song.settings.transpose = 0
        self.editor.song.content = content
        self.scene.originalSource = content
        self.settings.editor.showEditor = showEditor
        if let url {
            self.editor.song.settings.templateURL = url
        }
        self.scene.showWelcome = false
    }

    mutating func saveSong(_ song: Song) {
        if let fileURL = self.editor.song.settings.fileURL {
            try? self.editor.song.content.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the content as  saved
            self.scene.originalSource = self.editor.song.content
            /// Add it to the recent songs list
            self.addRecentSong(song: song)
        } else {
            self.scene.saveSongAs.signal()
        }
    }

    mutating func showWelcomeScreen() {
        print("Show Welcome Screen")
        self.editor.song.content = ""
        self.scene.originalSource = ""
        self.editor.song.settings.fileURL = nil
        self.scene.showWelcome = true
        /// Give the scene a new ID
        self.scene.id = UUID()
        /// Reset the editor
        self.editor = SourceViewBridge(song: Song(id: UUID(), content: ""))
    }
}

extension AppState {

    enum SaveDoneAction {
        case closeWindow
        case showWelcomeScreen
        case noAction
    }
}

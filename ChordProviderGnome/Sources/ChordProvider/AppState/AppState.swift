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
import CAdw

/// The state of **Chord Provider**
struct AppState {

    /// Init the `AppState`
    init() {

        // MARK: Load settings

        /// General settings
        if let settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            self.settings = settings
        } else {
            print("No settings found, creating new one")
        }
        /// The size of the window
        if let windowSize = try? SettingsCache.get(id: "ChordProviderGnome-window", struct: AppState.WindowSize.self) {
            print("Loaded window size")
            self.window = windowSize
        }
        /// Recent songs
        if let recentSongs = try? SettingsCache.get(id: "ChordProviderGnome-recent", struct: [AppState.RecentSong].self) {
            self.recentSongs = recentSongs
        }
    }
    /// The shared application settings
    var settings = AppSettings() {
        didSet {
            if settings != oldValue {
                try? SettingsCache.set(id: "ChordProviderGnome", object: self.settings)
            }
        }
    }
    /// Debounce window saving or else it got nuts when resizing the window
    let saveWindowDebouncer = Debouncer(delay: 1)
    /// The size of the window
    /// - Note: Will be used when opening a new instance of **ChordProvider**
    var window = WindowSize() {
        didSet {
            if window != oldValue {
                let window = window
                saveWindowDebouncer.schedule {
                    print("Saving window size")
                    try? SettingsCache.set(id: "ChordProviderGnome-window", object: window)
                }
            }
        }
    }
    /// State of the `Scene`
    /// - Note: Stuff that is only relevant for the current instance of **ChordProvider**
    var scene = Scene()

    /// Recent songs
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
    mutating func addRecentSong() {
        if let fileURL = self.editor.song.settings.fileURL {
            var recentSongs = self.recentSongs
            /// Keep only relevant information
            let recent = ChordProParser.parse(
                song: Song(id: UUID(), content: self.scene.originalContent),
                settings: self.editor.song.settings,
                getOnlyMetadata: true
            )
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
        editor.song.content != scene.originalContent
    }
}

extension AppState {
    
    /// Open a sample song from the Bundle
    /// - Parameters:
    ///   - sample: The sample song
    ///   - showEditor: Bool to show the editor
    mutating func openSample(_ sample: String, showEditor: Bool) {
        if
            let sampleSong = Bundle.module.url(forResource: "Samples/Songs/\(sample)", withExtension: "chordpro"),
            let content = try? String(contentsOf: sampleSong, encoding: .utf8) {
            self.editor.song.settings.fileURL = nil
            openSong(content: content, showEditor: showEditor, templateURL: sampleSong)
        } else {
            print("Error loading sample song")
        }
    }

    /// Open a song from an URL
    mutating func openSong(fileURL: URL) {
        do {
            let content = try SongFileUtils.getSongContent(fileURL: fileURL)
            self.editor.song.settings.fileURL = fileURL
            openSong(content: content, showEditor: self.settings.editor.showEditor)
            self.scene.toastMessage = "Opened \(fileURL.deletingPathExtension().lastPathComponent)"
            self.addRecentSong()
        } catch {
            self.scene.toastMessage = "Could not open the song"
        }
    }

    /// Open a song with its content as string
    /// - Parameter content: The content of the song
    mutating private func openSong(content: String, showEditor: Bool, templateURL: URL? = nil) {
        /// Reset transpose
        self.editor.song.settings.transpose = 0
        self.editor.song.metadata.transpose = 0
        /// Don't show the previous song
        self.editor.song.hasContent = false
        self.editor.song.content = content
        self.scene.originalContent = content
        self.settings.editor.showEditor = showEditor
        if let templateURL {
            self.editor.song.settings.templateURL = templateURL
        }
        /// Give the song a new ID
        /// - Note: That will make a new View
        self.editor.song.id = UUID()
        /// Close the welcome
        self.scene.showWelcomeView = false
    }

    mutating func saveSong(_ song: Song) {
        if let fileURL = self.editor.song.settings.fileURL {
            try? self.editor.song.content.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            /// Remember the content as  saved
            self.scene.originalContent = self.editor.song.content
            /// Add it to the recent songs list
            self.addRecentSong()
        } else {
            self.scene.saveSongAs.signal()
        }
    }
}

extension AppState {
    
    /// What to do when saving a song
    enum SaveDoneAction {
        /// Close the window
        case closeWindow
        /// Show the welcome view
        case showWelcomeView
        /// Do nthing
        case noAction
    }
}

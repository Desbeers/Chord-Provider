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
import CChordProvider

/// The state of **Chord Provider**
struct AppState {

    /// Init the `AppState` and load the settings
    init() {

        // MARK: Load settings

        /// General settings
        if let settings = try? SettingsCache.get(id: "ChordProviderGnome", struct: AppSettings.self) {
            print("Loaded settings")
            self.settings = settings
            /// Restore settings
            self.editor.song.settings = self.settings.core
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
            /// Update the style if needed
            if settings.editor.fontSize != oldValue.editor.fontSize || settings.app.zoom != oldValue.app.zoom {
                Markup.updateStyle(
                    zoom: self.settings.app.zoom,
                    dark: app_prefers_dark_theme() == 1 ? true : false,
                    editorFontSize: self.settings.editor.fontSize.rawValue
                )
                /// Store the new values
                /// - Note: Needed if the user switching from light to dark or visa versa
                self.styleState.pointee.editor_font_size = Int32(self.settings.editor.fontSize.rawValue)
                self.styleState.pointee.zoom = self.settings.app.zoom
            }
            //// Save the settings
            if settings != oldValue {
                print("Save Settings")
                try? SettingsCache.set(id: "ChordProviderGnome", object: self.settings)
            }
        }
    }
    /// Debounce window saving or else it got nuts when resizing the window
    let saveWindowDebouncer = Utils.Debouncer(delay: 1)
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
    /// The state of the `Scene`
    /// - Note: Stuff that is only relevant for the current instance of **ChordProvider**
    var scene = Scene()

    /// The state of the style
    let styleState = UnsafeMutablePointer<stylestate>.allocate(capacity: 1)

    /// The list of *Recent songs*
    var recentSongs: [RecentSong] = [] {
        didSet {
            print("Saving recent songs")
            try? SettingsCache.set(id: "ChordProviderGnome-recent", object: self.recentSongs)
        }
    }

    /// The source view bridge
    var editor = SourceViewBridge(song: Song(id: UUID(), content: "")) {
        didSet {
            if editor.song.settings != oldValue.song.settings {
                self.settings.core = self.editor.song.settings
            }
        }
    }

    /// The `GtkSourceEditor`class to communicate with `Swift`
    /// - Note: A lot of `C` stuff is easier with a `class`
    var controller: SourceViewController?
}

extension AppState {

    // MARK: Calculated stuff

    /// The subtitle of the `Scene`
    /// - Note: Using the URL, *not* the metadata of the song
    var subtitle: String {
        let lastPathComponent = editor.song.settings.fileURL?.deletingPathExtension().lastPathComponent
        return "\(lastPathComponent ?? "New Song")\(contentIsModified ? " - modified" : "")"
    }

    /// Bool if the content of the song is modified
    /// - Note: Comparing the source with the original source
    var contentIsModified: Bool {
        editor.song.content != scene.originalContent
    }
}

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
    /// The shared application settings
    var settings = AppSettings() {
        didSet {
            /// Update the style if needed
            if settings.editor.fontSize != oldValue.editor.fontSize || settings.app.zoom != oldValue.app.zoom {
                self.setStyle()
            }
        }
    }
    /// The state of the `Scene`
    /// - Note: Stuff that is only relevant for the current instance of **ChordProvider**
    var scene = Scene()
    /// The list of *Recent songs*
    //var recentSongs: [RecentSong] = []
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
    /// The `Adwaita` style manager
    let styleManager = adw_style_manager_get_default()
    /// The current CSS provider
    var currentCssProvider: UnsafeMutablePointer<GtkCssProvider>?
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

extension AppState: Codable {
    
    /// Items to save in the database
    enum CodingKeys: String, CodingKey {
        /// Only save the settings
        case settings
    }
}

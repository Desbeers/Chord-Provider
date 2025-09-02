//
//  File.swift
//  ChordProvider
//
//  Created by Nick Berendsen on 01/09/2025.
//

import Foundation
import Adwaita
import ChordProviderCore

/// The settings for the application
struct AppSettings {
    /// Core settings
    var core = ChordProviderSettings()
    /// Application specific settings
    var app = App()
}

extension AppSettings {

    /// Settings for the application
    struct App {
        /// The source of the song
        var source = sampleSong
        /// The original source of the song when opened or created
        var originalSource = sampleSong
        /// A signal to open a song
        var openSong = Signal()
        /// A signal to save as song with a new name
        var saveSongAs = Signal()
        /// The optional URL of a song
        /// - Note: A new song does not have an URL
        var songURL: URL?
        /// Show the *About* dialog
        var aboutDialog = false
        /// The position of the splitter``
        var splitter: Int = 0
        /// Bool if the editor is shown
        var showEditor: Bool = false
        /// Bool if the source is modified
        /// - Note: Comparing the source with the original source
        var dirty: Bool {
            source != originalSource
        }
        /// The subtitle for the application
        var subtitle: String {
            "\(songURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(dirty ? " - edited" : "")"
        }
    }
}

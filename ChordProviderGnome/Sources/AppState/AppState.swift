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
            /// Restore the splitter position when the editor is open
            if settings.editor.showEditor {
                settings.editor.splitter = settings.editor.restoreSplitter
            }
            self.settings = settings
        } else {
            print("No settings found, creating new one")
        }
        /// Open an optional song URL
        if let fileURL = CommandLine.arguments[safe: 1] {
            let url = URL(filePath: fileURL)
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
            settings.editor.splitter = 0
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

    /// The subtitle for the scene
    var subtitle: String {
        "\(settings.core.fileURL?.deletingPathExtension().lastPathComponent ?? "New Song")\(scene.dirty ? " - edited" : "")"
    }
}



extension AppState {

    enum SaveDoneAction {
        case close
        case openSong
        case noAction
    }
}

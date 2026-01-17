//
//  ChordProvider.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

/// The **Chord Provider** application
@main struct ChordProvider: App {
    /// Init the application
    init() {
        /// - Note: Give it an unique ID so Files does not open new windows
        let id: UUID = UUID()
        self.app = AdwaitaApp(id: "nl.desbeers.chordprovider._\(id.uuidString)")
    }
    /// The application
    let app: AdwaitaApp
    /// The state of the application
    /// - Note: This will load all the settings
    @State private var appState = AppState()
    /// The body of the `Scene`
    var scene: Scene {

        // MARK: Main Window

        Window(id: "main") { window in
            Views.Content(
                app: app,
                window: window,
                appState: $appState
            )
            .inspectOnAppear { storage in
                /// Init the `GtkSourceView`controller
                appState.controller = SourceViewController(bridge: $appState.editor, language: .chordpro)
                /// Init the css style
                appState.setStyle()
                /// Add a *notification* for style changes
                storage.notify(name: "dark", pointer: appState.styleManager) {
                    appState.setStyle()
                }
                /// Open a song when passed as argument at launch
                /// - Note: When opened again with another argument; it will create a new instance because the application will have a another ID
                if let fileURL = CommandLine.arguments[safe: 1] {
                    let url = URL(filePath: fileURL)
                    /// - Note: Hide the editor because it is flashing if a song is directly opened
                    appState.settings.editor.showEditor = false
                    appState.openSong(fileURL: url)
                }
            }
        }
        /// - Note: It will remember the window size when opening a new window
        .size(width: $appState.window.width, height: $appState.window.height)
        .defaultSize(width: 800, height: 600)
        .minSize(width: 800, height: 600)
        .onClose {
            if appState.contentIsModified {
                appState.scene.saveDoneAction = .closeWindow
                appState.scene.showCloseDialog = true
                return .cancel
            } else {
                return .close
            }
        }

        // MARK: Database Window

        Window(id: "database", open: 0) { _ in
            Views.Database()
        }
        /// - Note: I don't store its window size
        .minSize(width: 800, height: 600)
        .defaultSize(width: 800, height: 600)
        .title("Chords Database")
    }
}

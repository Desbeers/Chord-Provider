//
//  ChordProvider.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import Foundation
import CChordProvider

/// The **Chord Provider** application
@main struct ChordProvider: App {
    /// Give it an unique ID so Files does not open new windows
    let app = AdwaitaApp(id: "nl.desbeers.chordprovider._\(UUID().uuidString)")
    /// The ``AppSettings``
    @State private var appState = AppState()
    /// The body of the `Scene`
    var scene: Scene {
        Window(id: "main") { window in
            Views.Content(
                app: app,
                window: window,
                appState: $appState,
                id: UUID()
            )
            .css {
                Markup.css(
                    zoom: appState.settings.app.zoom,
                    dark: app_prefers_dark_theme() == 1 ? true : false
                )
            }
        }
        .size(width: $appState.settings.app.width, height: $appState.settings.app.height)
        .defaultSize(width: 800, height: 600)
        .title(appState.subtitle)
        .onClose {
            if appState.scene.dirty {
                appState.scene.saveDoneAction = .closeWindow
                appState.scene.showDirtyClose = true
                return .cancel
            } else {
                return .close
            }
        }
        Window(id: "database", open: 0) { _ in
            Views.Database(settings: appState.settings)
        }
        .defaultSize(width: 800, height: 600)
        .title("Chords Database")
    }
}

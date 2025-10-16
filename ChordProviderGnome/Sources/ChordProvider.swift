//
//  ChordProvider.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import Foundation

/// The **Chord Provider** application
@main struct ChordProvider: App {
    /// Give it an unique ID so Files does not open new windows
    let app = AdwaitaApp(id: "nl.desbeers.chordprovider._\(UUID().uuidString)")

    @State("width") private var width = 800
    @State("height") private var height = 600

    /// The ``AppSettings``
    @State private var appState = AppState()

    var scene: Scene {
        Window(id: "main") { window in
            ContentView(
                app: app,
                window: window,
                appState: $appState,
                id: UUID()
            )
        }
        .size(width: $width, height: $height)
        .defaultSize(width: 800, height: 600)
        .title(appState.subtitle)
        .onClose {
            if appState.scene.dirty {
                appState.scene.saveDoneAction = .close
                appState.scene.showDirtyClose = true
                return .keep
            } else {
                return .close
            }
        }
    }
}

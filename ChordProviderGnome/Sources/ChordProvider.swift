//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita

@main
struct ChordProvider: App {

    let app = AdwaitaApp(id: "nl.desbeers.chordprovider")

    var scene: Scene {
        Window(id: "main") { window in
            ContentView(app: app, window: window)
        }
        .defaultSize(width: 800, height: 600)
        .deletable(false)
    }
}

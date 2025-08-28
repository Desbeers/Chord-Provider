//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita

@main
struct AdwaitaTemplate: App {

    let app = AdwaitaApp(id: "nl.desbeers.chordprovider")

    var scene: Scene {
        Window(id: "main") { window in
            ContentView(app: app, window: window)
        }
        .title("Chord Provider")
        .defaultSize(width: 800, height: 600)
    }
}

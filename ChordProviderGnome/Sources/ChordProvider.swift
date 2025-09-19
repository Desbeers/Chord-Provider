//
//  ChordProvider.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita

/// The Chord Provider application
@main struct ChordProvider: App {

    let app = AdwaitaApp(id: "nl.desbeers.chordprovider")

    @State("width") private var width = 800
    @State("height") private var height = 600

    var scene: Scene {
        Window(id: "main") { window in
            ContentView(app: app, window: window)
        }
        .size(width: $width, height: $height)
        .defaultSize(width: 800, height: 600)
    }
}

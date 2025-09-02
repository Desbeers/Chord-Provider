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
//            SplitView {
//                Text("Links")
//            } end: {
//                Text("Rechts")
//            }

            ContentView(app: app, window: window)
        }
        .defaultSize(width: 800, height: 600)
    }
}

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Adwaita

@main
struct AdwaitaTemplate: App {

    let app = AdwaitaApp(id: "nl.desbeers.chordprovider")

    var scene: Scene {
        Window(id: "main") { window in
            ContentView(app: app, window: window)
        }
        .title("Chord Provider")
        .defaultSize(width: 450, height: 300)
    }

}

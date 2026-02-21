// The Swift Programming Language
// https://docs.swift.org/swift-book

import Adwaita

@main
struct AdwaitaDebug: App {

    let app = AdwaitaApp(id: "nl.desbeers.adwaitadebug")

    var scene: Scene {
        Window(id: "main") { window in
            Content(app: app, window: window)
        }
        .defaultSize(width: 800, height: 600)
        .quitShortcut()
        .closeShortcut()
        .devel()
    }
}

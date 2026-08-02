// The Swift Programming Language
// https://docs.swift.org/swift-book

import Adwaita

@main
struct AdwaitaDebugApp: App {

    var app = AdwaitaApp(id: "nl.desbeers.adwaitadebug")

    var scene: Scene {
        Window(id: "main") { window in
            Main()
                .topToolbar {
                    HeaderBar
                        .empty()
                }
        }
    }
}

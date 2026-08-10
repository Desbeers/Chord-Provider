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
        .title("Orientation, Expanding & Alignment")
        .defaultSize(width: 800, height: 600)
    }
}

enum Tab: String, CaseIterable {
    case separator
    case forEach
    case either
    case switching
}

enum Filler: String {
    case left
    case center
    case right

    case one
    case two
    case three
    case four

    static var numbers: [Filler] {
        [.one, .two, .three, .four]
    }
}
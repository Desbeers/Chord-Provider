//
//  SourceViewDemo.swift
//  SourceViewDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita

/// The **SourceView** demo application
@main
struct SourceViewDemo: App {

    /// The application
    let app = AdwaitaApp(id: "nl.desbeers.sourceviewdemo")
    /// The state of the application
    @State("demo")
    private var appState = AppState()
    /// The body of the `Scene`
    var scene: Scene {
        Window(id: "main") { window in
            MainView(app: app, window: window, appState: $appState)
        }
        .defaultSize(width: 600, height: 600)
    }
}

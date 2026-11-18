//
//  Demo.swift
//  SourceEditorDemo
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import SourceEditor
import CSourceEditor
import CAdw

/// The **SourceEditor** demo application
@main
struct Demo: App {

    /// The application
    let app = AdwaitaApp(id: "nl.desbeers.sourceeditordemo")
    /// The state of the application
    @State("demo")
    private var appState = AppState()
    /// The body of the `Scene`
    var scene: Scene {
        Window(id: "main") { window in
            MainView(app: app, window: window, appState: $appState)
            .inspectOnAppear { storage in
                // Setup the `GtkSourceView`controller
                appState.controller.setup(
                    bridge: $appState.bridge,
                    scheme: $appState.options.scheme,
                    storage: storage,
                    onOpen: { result in
                        switch result {
                            case .success:
                            print("CALLBACK SUCCESS!")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                )
            }
        }
        .title("Source Editor Demo")
        .defaultSize(width: 600, height: 600)
        .onOpen { urls in
            guard let fileURL = urls.first else {
                // Just open the *home* window
                return
            }
            if let text = try? String(contentsOf: fileURL, encoding: .utf8) {
                appState.fileURL = fileURL
                appState.controller.command(.newFile(text, url: fileURL))
                print("open file")
            } else {
                print(fileURL)
            }
            app.showWindow("main")
        }
    }
}

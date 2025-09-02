//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct ContentView: View {
    var app: AdwaitaApp
    var window: AdwaitaWindow
    @State private var settings = AppSettings()
    let id = UUID()

    var view: Body {

        SplitView(splitter: $settings.app.splitter) {
            EditorView(settings: $settings)
        } end: {
            VStack {
                RenderView(render: settings.app.source, id: id, settings: settings)
                    .hexpand()
                    .vexpand()
                if settings.app.splitter != 0 {
                    LogView()
                        .transition(.coverUpDown)
                }
            }

            //.hexpand()
        }
        //.transition(.crossfade)

        .vexpand()
        .hexpand()
        .topToolbar {
            ToolbarView(
                app: app,
                window: window,
                settings: $settings
            )
        }
        .fileImporter(
            open: settings.app.openSong,
            extensions: ["chordpro", "cho"]
        ) { url in
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                settings.app.songURL = url
                settings.app.source = content
                settings.app.originalSource = content
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: settings.app.saveSongAs,
            initialName: settings.app.songURL?.lastPathComponent ?? "Untitled.chordpro",
        ) { url in
            settings.app.songURL = url
            try? settings.app.source.write(to: url, atomically: true, encoding: String.Encoding.utf8)
            settings.app.originalSource = settings.app.source
        } onClose: {
            /// Nothing to do
        }
    }
}

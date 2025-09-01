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
        OverlaySplitView(visible: $settings.app.showEditor) {
            VStack {
                EditorView(text: $settings.app.text)
                HStack {
                    Button("Clean Source") {
                        let song = Song(id: id, content: settings.app.text)
                        let result = ChordProParser.parse(
                            song: song,
                            instrument: settings.core.instrument,
                            prefixes: [],
                            getOnlyMetadata: false
                        )
                        settings.app.text = result.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                    }
                    .pill()
                    .padding(4, .bottom)
                }
                .halign(.center)
            }
        } content: {
            VStack {
                RenderView(render: settings.app.text, id: id, settings: settings)
                    .hexpand()
                    .vexpand()
                if settings.app.showEditor {
                    LogView()
                        .transition(.coverUpDown)
                }
            }
        }
        .minSidebarWidth(500)
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
                settings.app.text = content
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: settings.app.saveSongAs,
            initialName: settings.app.songURL?.lastPathComponent ?? "Untitled.chordpro",
        ) { url in
            settings.app.songURL = url
            try? settings.app.text.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } onClose: {
            /// Nothing to do
        }
    }
}

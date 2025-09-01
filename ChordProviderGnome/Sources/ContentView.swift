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
    @State private var text = sampleSong
    @State private var showEditor = false
    @State private var openSong = Signal()
    @State private var saveSongAs = Signal()
    @State private var songURL: URL?
    @State private var aboutDialog = false
    @State private var lyricsOnly = false
    @State private var settings: ChordProviderSettings = .init()
    let id = UUID()

    var view: Body {
        OverlaySplitView(visible: $showEditor) {
            VStack {
                EditorView(text: $text)
                HStack {
                    Button("Clean Source") {
                        let song = Song(id: id, content: text)
                        let result = ChordProParser.parse(
                            song: song,
                            instrument: .guitar,
                            prefixes: [],
                            getOnlyMetadata: false
                        )
                        text = result.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                    }
                    .pill()
                    .padding(4, .bottom)
                }
                .halign(.center)
            }
        } content: {
            VStack {
                RenderView(render: text, id: id, settings: settings)
                    .hexpand()
                    .vexpand()
                if showEditor {
                    LogView()
                        .transition(.coverUpDown)
                }
            }
        }
        .minSidebarWidth(500)
        .topToolbar {
            HeaderBar {
                Toggle(icon: .default(icon: .textEditor), isOn: $showEditor)
                    .tooltip("Show Editor")
                Toggle(icon: .default(icon: .tv), isOn: $settings.options.lyricOnly)
                    .tooltip("Show only lyrics")
            } end: {
                ToolbarView(
                    openSong: $openSong,
                    saveSongAs: $saveSongAs,
                    songURL: $songURL,
                    lyricsOnly: $lyricsOnly,
                    text: text,
                    app: app,
                    window: window
                )
            }
        }
        .fileImporter(
            open: openSong,
            extensions: ["chordpro", "cho"]
        ) { url in
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                songURL = url
                text = content
            }
        } onClose: {
            /// Nothing to do
        }
        .fileExporter(
            open: saveSongAs,
            initialName: songURL?.lastPathComponent ?? "Untitled.chordpro",
        ) { url in
            songURL = url
            try? text.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        } onClose: {
            /// Nothing to do
        }
    }
}

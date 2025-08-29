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

    var view: Body {
        OverlaySplitView(visible: $showEditor) {
            EditorView(text: $text)
        } content: {
            VStack {
                RenderView(render: text)
                    .hexpand()
                    .vexpand()
            }
        }
        .minSidebarWidth(500)
        .topToolbar{
            HeaderBar {
                Toggle(icon: .default(icon: .textEditor), isOn: $showEditor)
                    .tooltip("Show Editor")
            } end: {
                ToolbarView(
                    openSong: $openSong,
                    saveSongAs: $saveSongAs,
                    songURL: $songURL,
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

//
//  File.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct ContentView: View {
    
    var app: AdwaitaApp
    var window: AdwaitaWindow
    @State private var text = sampleSong
    @State private var showEditor = false
    @State private var fileDialog = Signal()

    var view: Body {
        OverlaySplitView(visible: $showEditor) {
            EditorView(text: $text)
        } content: {
            VStack {
                RenderView(render: text)
                    .hexpand()
                    .vexpand()
                HStack {
                    Button("Open another Song") {
                        fileDialog.signal()
                    }
                    .pill()
                }
                .halign(.center)
                .padding()
            }
        }
        .minSidebarWidth(500)
        .topToolbar {
            HeaderBar {
                Toggle(icon: .default(icon: .textEditor), isOn: $showEditor)
                    .tooltip("Show Editor")
            } end: {
                ToolbarView(app: app, window: window)
            }
        }
        .fileImporter(open: fileDialog, extensions: ["chordpro"]) {
            let fileURL = $0
            if let content = try? String(contentsOf: fileURL, encoding: .utf8) {
                text = content
            }
        } onClose: {
            /// Nothing to do
        }
    }
}

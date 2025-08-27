//
//  File.swift
//  Adwaita Template
//
//  Created by Nick Berendsen on 27/08/2025.
//

import Foundation
import Adwaita
import ChordProviderCore
import ChordProviderHTML

struct ContentView: View {

    var app: AdwaitaApp
    var window: AdwaitaWindow

    @State private var text = "Open a song to view"

    @State private var fileDialog = Signal()
    var view: Body {
        VStack(spacing: 20) {
            RenderView(render: text)
                .hexpand()
                .vexpand()
            Button("Open Song") {
                fileDialog.signal()
            }
            .halign(.center)
            .pill()
            .suggested()
            .padding()
        }
        .topToolbar {
            ToolbarView(app: app, window: window)
        }
        .fileImporter(open: fileDialog, extensions: ["chordpro"]) {
            let url = $0
            Task {
                if let result = try? await SongFileUtils.parseSongFile(fileURL: url, instrument: .guitar, prefixes: [], getOnlyMetadata: false) {
                    text = HtmlRender.render(song: result, settings: .init())
                } else {
                    print("ERROR: Failed to parse file")
                }
            }
        } onClose: {
            /// Nothing to do
        }
    }
}

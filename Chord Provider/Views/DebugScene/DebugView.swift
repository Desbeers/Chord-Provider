//
//  DebugView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the debug window
struct DebugView: View {
    /// The observable state of the application
    @Environment(AppStateModel.self) var appState
    /// State of the Scene
    @Environment(\.scenePhase) var scenePhase
    /// The currently selected tab
    @State private var tab: Message = .log
    /// The source of the song
    @State var source: [(line: Int, source: Song.Section.Line)] = []
    /// The currently selected line
    @State var selectedLine: Int?
    /// JSON part
    @State var jsonPart: Part = .metadata
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            switch tab {
            case .log:
                logView
            case .json:
                jsonView
            case .source:
                sourceView
            }
        }
        .frame(minWidth: 500, minHeight: 600)
        .frame(maxWidth: .infinity)
        .background(Color(NSColor.textBackgroundColor))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("Tab", selection: $tab) {
                    ForEach(Message.allCases, id: \.self) { tab in
                        Label(tab.rawValue, systemImage: "gear")
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .labelStyle(.titleAndIcon)
        .animation(.default, value: appState.song)
        .animation(.default, value: tab)
        .task(id: appState.song) {
            if scenePhase == .active {
                await getSource()
            }
        }
        .task(id: scenePhase) {
            if scenePhase == .active {
                await getSource()
            }
        }
        .task(id: tab) {
            selectedLine = nil
        }
    }

    /// No song View
    var noSong: some View {
        ContentUnavailableView("No song open", systemImage: "music.quarternote.3")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

@MainActor struct ChordsDatabaseView: View {

    /// The observable state of the application
    @State var appState = AppStateModel(id: .chordsDatabaseView)
    /// The state of the scene
    @State var sceneState = SceneStateModel(id: .chordsDatabaseView)
    /// The observable state of the chords database
    @State var chordsDatabaseState = ChordsDatabaseStateModel()
    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme

//    /// The chord for the 'delete' action
//    @State var actionButton: ChordDefinition?

    /// The conformation dialog to delete a chord
    @State var showDeleteConfirmation = false

    /// The body of the `View`
    var body: some View {
        NavigationStack(path: $chordsDatabaseState.navigationStack.animation(.smooth)) {
            VStack(spacing: 0) {
                grid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                options
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(.ultraThinMaterial)
            }
            .navigationDestination(for: ChordDefinition.self) { chord in
                ChordsDatabaseView.EditView(chord: chord)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .searchable(text: $chordsDatabaseState.search, placement: .automatic, prompt: Text("Search chords"))
            .opacity(chordsDatabaseState.navigationStack.isEmpty ? 1 : 0)
        }
        .frame(minWidth: 800, minHeight: 600)
        .background(Color(nsColor: .textBackgroundColor))
        .scaleModifier
        .animation(.default, value: chordsDatabaseState.navigationStack)
        .animation(.default, value: chordsDatabaseState.chords)
        .animation(.smooth, value: appState.settings)
        .animation(.smooth, value: sceneState.settings)
        .animation(.smooth, value: chordsDatabaseState.editChords)
        .task(id: sceneState.settings.song.instrument) {
            chordsDatabaseState.allChords = Chords.getAllChordsForInstrument(instrument: sceneState.settings.song.instrument)
        }
        .onChange(of: chordsDatabaseState.allChords) {
            filterChords()
        }
        .task(id: sceneState.definition) {
            filterChords()
        }
        .onChange(of: chordsDatabaseState.search) {
            if chordsDatabaseState.search.isEmpty {
                filterChords()
            } else {
                chordsDatabaseState.chords = chordsDatabaseState.allChords.filter { $0.name.localizedCaseInsensitiveContains(chordsDatabaseState.search) }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.bass), KeyPathComparator(\.quality)
                        ]
                    )
            }
        }
        .onChange(of: sceneState.settings) {
            appState.settings.song = sceneState.settings.song
        }
        .toolbar {
            sceneState.scaleSlider
                .frame(width: 80)
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
        }
        .fileExporter(
            isPresented: $chordsDatabaseState.showExportSheet,
            document: ChordsDatabaseDocument(string: chordsDatabaseState.exportData),
            contentTypes: [.json],
            defaultFilename: "ChordPro \(sceneState.settings.song.instrument) chords"
        ) { result in
            if case .success = result {
                print("Success")
            } else {
                print("Failure")
            }
        }
        .navigationSubtitle(sceneState.settings.song.instrument.description)
        .environment(sceneState)
        .environment(appState)
        .environment(chordsDatabaseState)
    }

    func filterChords() {
        var chords = chordsDatabaseState.allChords

        if sceneState.definition.root != .all {
            chords = chords.matching(root: sceneState.definition.root)
        }
        if sceneState.definition.quality != .unknown {
            chords = chords.matching(quality: sceneState.definition.quality)
        }
        chordsDatabaseState.chords = chords.sorted(using: [
            KeyPathComparator(\.root), KeyPathComparator(\.bass), KeyPathComparator(\.quality)
        ])
    }
}

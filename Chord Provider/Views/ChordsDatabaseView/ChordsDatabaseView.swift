//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the chords database
struct ChordsDatabaseView: View {
    /// The observable state of the application
    @State var appState = AppStateModel(id: .chordsDatabaseView)
    /// The state of the scene
    @State var sceneState = SceneStateModel(id: .chordsDatabaseView)
    /// The observable state of the chords database
    @State var chordsDatabaseState = ChordsDatabaseStateModel()
    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme
    /// The conformation dialog to delete a chord
    @State var showDeleteConfirmation = false

    @State private var window: NSWindow?

    /// The body of the `View`
    var body: some View {
        NavigationStack(path: $chordsDatabaseState.navigationStack.animation(.smooth)) {
            VStack(spacing: 0) {
                grid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                options
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(.ultraThinMaterial)
            }
            .navigationDestination(for: ChordDefinition.self) { chord in
                ChordsDatabaseView.EditView(chord: chord, window: window)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .searchable(text: $chordsDatabaseState.search, placement: .toolbar, prompt: Text("Search chords"))
                    .navigationBarBackButtonHidden()
            }
            .searchable(text: $chordsDatabaseState.search, placement: .toolbar, prompt: Text("Search chords"))
            .opacity(chordsDatabaseState.navigationStack.isEmpty ? 1 : 0)
        }
        .withHostingWindow { window in
            self.window = window
        }
        .dismissalConfirmationDialog(
            "The Chords Database has changed",
            shouldPresent: window?.isDocumentEdited ?? false,
            actions: {
                Button("No") {
                    window?.close()
                }
                Button("Yes", role: .cancel) {
                    chordsDatabaseState.showExportSheet = true
                }
            },
            message: {
                Text("Do you want to save your database?")
            }
        )
        .frame(minWidth: 860, minHeight: 620)
        .background(Color(nsColor: .textBackgroundColor))
        .scaleModifier
        .animation(.default, value: chordsDatabaseState.navigationStack)
        .animation(.default, value: chordsDatabaseState.chords)
        .animation(.smooth, value: appState.settings)
        .animation(.smooth, value: sceneState.settings)
        .task(id: sceneState.settings.song.display.instrument) {
            chordsDatabaseState.allChords = Chords.getAllChordsForInstrument(instrument: sceneState.settings.song.display.instrument)
        }
        .task {
            /// Set defaults
            sceneState.settings.song.diagram.showNotes = true
            sceneState.settings.song.diagram.showPlayButton = true
        }
        .onChange(of: chordsDatabaseState.allChords) {
            filterChords()
        }
        .onChange(of: chordsDatabaseState.navigationStack) {
            if chordsDatabaseState.navigationStack.isEmpty {
                sceneState.definition.status = .standardChord
            }
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
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
        }
        .fileExporter(
            isPresented: $chordsDatabaseState.showExportSheet,
            document: ChordsDatabaseDocument(string: chordsDatabaseState.exportData),
            contentTypes: [.json],
            defaultFilename: "ChordPro \(sceneState.settings.song.display.instrument) chords"
        ) { result in
            if case .success = result {
                print("Success")
                window?.isDocumentEdited = false
            } else {
                print("Failure")
            }
        }
        .navigationSubtitle(sceneState.settings.song.display.instrument.description)
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

//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import OSLog

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
    /// Option to hide correct chords
    @State var hideCorrectChords = false
    /// The `NSWindow` of this `View`
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
        .animation(.smooth, value: sceneState.song.settings)
        .task(id: sceneState.song.settings.display.instrument) {
            chordsDatabaseState.allChords = Chords.getAllChordsForInstrument(instrument: sceneState.song.settings.display.instrument)
        }
        .task {
            /// Set defaults
            sceneState.song.settings.diagram.showNotes = true
            sceneState.song.settings.diagram.showPlayButton = true
        }
        .onChange(of: chordsDatabaseState.allChords) {
            filterChords()
        }
        .onChange(of: hideCorrectChords) {
            filterChords()
        }
        .onChange(of: chordsDatabaseState.navigationStack) {
            if chordsDatabaseState.navigationStack.isEmpty {
                sceneState.definition.status = .standardChord
            }
        }
        .task(id: chordsDatabaseState.gridRoot) {
            filterChords()
        }
        .task(id: chordsDatabaseState.gridQuality) {
            filterChords()
        }
        .onChange(of: chordsDatabaseState.search) {
            if chordsDatabaseState.search.isEmpty {
                filterChords()
            } else {
                chordsDatabaseState.chords = chordsDatabaseState.allChords.filter { $0.name.localizedCaseInsensitiveContains(chordsDatabaseState.search) }
                    .sorted(
                        using: [
                            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
                        ]
                    )
            }
        }
        .onChange(of: sceneState.song.settings.display) {
            appState.settings.display = sceneState.song.settings.display
        }
        .toolbar {
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
                .disabled(!chordsDatabaseState.navigationStack.isEmpty)
        }
        .fileExporter(
            isPresented: $chordsDatabaseState.showExportSheet,
            document: JSONDocument(string: chordsDatabaseState.exportData),
            contentTypes: [.json],
            defaultFilename: "ChordPro \(sceneState.song.settings.display.instrument) chords"
        ) { result in
            switch result {
            case .success(let url):
                Logger.fileAccess.info("Database exported to \(url, privacy: .public)")
            case .failure(let error):
                Logger.fileAccess.error("Export failed: \(error.localizedDescription, privacy: .public)")
            }
        }
        .navigationSubtitle(sceneState.song.settings.display.instrument.description)
        .environment(sceneState)
        .environment(appState)
        .environment(chordsDatabaseState)
    }

    /// Filter the chords
    func filterChords() {
        var chords = chordsDatabaseState.allChords

        if chordsDatabaseState.gridRoot != .all {
            chords = chords.matching(sharpAndflatRoot: chordsDatabaseState.gridRoot)
        }
        if chordsDatabaseState.gridQuality != .unknown {
            chords = chords.matching(quality: chordsDatabaseState.gridQuality)
        }
        if hideCorrectChords {
            chords = chords.filter { $0.validate != .correct }
        }
        chordsDatabaseState.chords = chords.sorted(using: [
            KeyPathComparator(\.root), KeyPathComparator(\.slash), KeyPathComparator(\.quality)
        ])
    }
}

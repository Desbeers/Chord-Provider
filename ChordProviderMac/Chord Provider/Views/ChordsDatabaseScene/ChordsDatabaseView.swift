//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI
import ChordProviderCore

/// SwiftUI `View` for the chords database
struct ChordsDatabaseView: View {
    /// The observable state of the application
    @State var appState = AppStateModel(id: .chordsDatabaseView)
    /// The state of the scene
    @State var sceneState = SceneStateModel(id: .chordsDatabaseView)
    /// The observable state of the chords database
    @State var chordsDatabaseState = ChordsDatabaseStateModel()
    /// The conformation dialog to delete a chord
    @State var showDeleteConfirmation = false
    /// Option to hide correct chords
    @State var hideCorrectChords = false
    /// The `NSWindow` of this `View`
    @State var window: NSWindow?
    /// The current instrument
    @State var currentInstrument: Chord.Instrument = .guitar
    /// The body of the `View`
    var body: some View {
        NavigationStack(path: $chordsDatabaseState.navigationStack.animation(.smooth)) {
            VStack(spacing: 0) {
                grid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                options
                    .frame(maxWidth: .infinity)
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
        .frame(minWidth: 860, minHeight: 620)
        .background(Color(nsColor: .textBackgroundColor))
        .scaleModifier
        .animation(.default, value: chordsDatabaseState.navigationStack)
        .animation(.default, value: chordsDatabaseState.chords)
        .animation(.smooth, value: appState.settings)
        .animation(.smooth, value: sceneState.settings)
        .withHostingWindow { window in
            self.window = window
        }
        .dismissalConfirmationDialog(
            "The Chords Database has changed",
            shouldPresent: window?.isDocumentEdited ?? false,
            actions: {
                Button("No") {
                    window?.isDocumentEdited = false
                    window?.close()
                }
                Button("Yes", role: .cancel) {
                    chordsDatabaseState.closeWindowAfterSaving = true
                    chordsDatabaseState.showExportSheet = true
                }
            },
            message: {
                Text("Do you want to save your database?")
            }
        )
        .confirmationDialog(
            "The Chords Database has changed",
            isPresented: $chordsDatabaseState.saveDatabaseConfirmation
        ) {
            Button("Yes") {
                chordsDatabaseState.loadInstrumentAfterSaving = true
                chordsDatabaseState.showExportSheet = true
            }
            Button("No", role: .cancel) {
                window?.isDocumentEdited = false
                getAllChords()
            }
        } message: {
            Text("Do you want to save the database before loading another instrument?")
        }
        .task(id: sceneState.settings.core.instrument) {
            if window?.isDocumentEdited ?? false {
                chordsDatabaseState.saveDatabaseConfirmation = true
            } else {
                getAllChords()
            }
        }
        .task {
            /// Set defaults
            appState.settings.core.diagram.showNotes = true
            appState.settings.diagram.showPlayButton = true
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
        .onChange(of: appState.settings.diagram) {
            sceneState.settings.diagram = appState.settings.diagram
        }
        .onChange(of: appState.settings.core.diagram) {
            sceneState.settings.core.diagram = appState.settings.core.diagram
        }
        .onChange(of: sceneState.settings.display) {
            appState.settings.display = sceneState.settings.display
        }
        /// Create the JSON before showing the export sheet
        .onChange(of: chordsDatabaseState.showExportSheet) {
            if chordsDatabaseState.showExportSheet {
                do {
                    chordsDatabaseState.exportData = try ChordUtils.exportToJSON(
                        definitions: chordsDatabaseState.allChords,
                        uniqueNames: false
                    )
                } catch {
                    LogUtils.shared.setLog(
                        level: .error,
                        category: .jsonParser,
                        message: error.localizedDescription
                    )
                }
            }
        }
        .toolbar {
            sceneState.instrumentPicker
                .pickerStyle(.segmented)
                .disabled(!chordsDatabaseState.navigationStack.isEmpty)
                .backport.glassEffect()
        }
        .fileExporter(
            isPresented: $chordsDatabaseState.showExportSheet,
            document: JSONDocument(string: chordsDatabaseState.exportData),
            contentTypes: [.json],
            defaultFilename: "ChordPro \(currentInstrument.label) chords",
            onCompletion: { result in
                switch result {
                case .success(let url):
                    Task {
                        LogUtils.shared.setLog(
                            level: .info,
                            category: .fileAccess,
                            message: "Database exported to \(url.lastPathComponent)"
                        )
                    }
                case .failure(let error):
                    LogUtils.shared.setLog(
                        level: .error,
                        category: .fileAccess,
                        message: "Export failed: \(error.localizedDescription)"
                    )
                }
                if chordsDatabaseState.closeWindowAfterSaving {
                    chordsDatabaseState.closeWindowAfterSaving = false
                    window?.isDocumentEdited = false
                    window?.close()
                }
                if chordsDatabaseState.loadInstrumentAfterSaving {
                    chordsDatabaseState.loadInstrumentAfterSaving = false
                    window?.isDocumentEdited = false
                    getAllChords()
                }
            },
            onCancellation: {
                chordsDatabaseState.closeWindowAfterSaving = false
                chordsDatabaseState.loadInstrumentAfterSaving = false
                chordsDatabaseState.showExportSheet = false
                chordsDatabaseState.saveDatabaseConfirmation = false
                sceneState.settings.core.instrument = currentInstrument
            }
        )
        .navigationSubtitle(currentInstrument.description)
        .environment(sceneState)
        .environment(appState)
        .environment(chordsDatabaseState)
    }

    /// Get all the chords for an instrument
    func getAllChords() {
        currentInstrument = sceneState.settings.core.instrument
        chordsDatabaseState
            .allChords = ChordUtils
            .getAllChordsForInstrument(instrument: currentInstrument)
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

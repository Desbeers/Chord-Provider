//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

@MainActor struct ChordsDatabaseView: View {

    /// The observable state of the application
    @State private var appState = AppStateModel(id: .chordsDatabaseView)
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .chordsDatabaseView)
    /// The observable state of the chords database
    @State private var chordsDatabaseState = ChordDatabaseStateModel()
    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme

    /// The chord for the 'delete' action
    @State private var actionButton: ChordDefinition?

    /// The conformation dialog to delete a chord
    @State private var showDeleteConfirmation = false

    /// The body of the `View`
    var body: some View {
        NavigationSplitView(
            sidebar: {
                List {
                    Group {
                        chordsDatabaseState.editChordsToggle
                        //HStack {
                        appState.mirrorToggle

                        appState.notesToggle
                        Spacer()
                        appState.midiInstrumentPicker
                        //}

                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                }
                Button {
                    do {
                        chordsDatabaseState.exportData = try Chords.exportToJSON(definitions: chordsDatabaseState.allChords)
                        chordsDatabaseState.showExportSheet.toggle()
                    } catch {
                        print(error)
                    }
                } label: {
                    Text("Export Chords to **ChordPro** format")
                }
                .padding()
                .navigationSplitViewColumnWidth(260)
            }, detail: {
                details
            }
        )
        .navigationSubtitle(sceneState.settings.song.instrument.description)
        .searchable(text: $chordsDatabaseState.search, placement: .sidebar, prompt: Text("Search chords"))
        .searchable(text: $chordsDatabaseState.search)
        .environment(sceneState)
        .environment(appState)
    }



    var details: some View {
        VStack {
            NavigationStack(path: $chordsDatabaseState.navigationStack) {
                VStack {
                    Group {
                        sceneState.rootPicker(showAll: true)
                            .pickerStyle(.segmented)
                            .labelsHidden()
                            .padding()
                        sceneState.qualityPicker()
                    }
                    .disabled(!chordsDatabaseState.search.isEmpty)
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 110 * sceneState.settings.song.scale + (chordsDatabaseState.editChords ? 40 : 0)), spacing: 0)],
                            alignment: .center,
                            spacing: 0,
                            pinnedViews: [.sectionHeaders, .sectionFooters]
                        ) {
                            ForEach(chordsDatabaseState.chords) { chord in
                                diagram(chord: chord)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(
                                        colorScheme == .dark ? Color.randomDark.opacity(0.2).shadow(radius: 4, x: 0, y: 10)
                                        : Color.randomLight.opacity(0.3).shadow(radius: 4, x: 0, y: 0)
                                    )
                                    .cornerRadius(12)
                                    .padding()
                            }
                        }
                    }
                    .overlay {
                        if !chordsDatabaseState.search.isEmpty && chordsDatabaseState.chords.isEmpty {
                            ContentUnavailableView(
                                "Nothing found",
                                systemImage: "magnifyingglass",
                                description: Text("No chords with the name **\(chordsDatabaseState.search)** found.")
                            )
                        }
                    }
                }

                .navigationDestination(for: ChordDefinition.self) { chord in
                    CreateChordView(sceneState: sceneState)
                }
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
        }
        .scaleModifier
        .frame(minWidth: 800, minHeight: 600)
        .animation(.default, value: chordsDatabaseState.chords)
        .animation(.smooth, value: appState.settings)
        .animation(.smooth, value: sceneState.settings)
        .animation(.smooth, value: chordsDatabaseState.editChords)
//        .searchable(text: $chordsDatabaseState.search)
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
    }

    func diagram(chord: ChordDefinition) -> some View {
        HStack {
            ChordDefinitionView(
                chord: chord,
                width: 100 * sceneState.settings.song.scale,
                settings: appState.settings
            )
            .foregroundStyle(
                .primary,
                colorScheme == .dark ? .black : .white
            )
            if chordsDatabaseState.editChords {
                actions(chord: chord)
            }
        }
    }

    func filterChords() {
        chordsDatabaseState.chords = chordsDatabaseState.allChords
            .matching(root: sceneState.definition.root)
            .matching(quality: sceneState.definition.quality)
            .sorted(using: [
                KeyPathComparator(\.root), KeyPathComparator(\.bass), KeyPathComparator(\.quality)
            ])
    }

    /// Chord actions
    private func actions(chord: ChordDefinition) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            editButton(chord: chord)
            duplicateButton(chord: chord)
            confirmDeleteButton(chord: chord)
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .confirmationDialog(
            "Delete \(actionButton?.root.display ?? "") \(actionButton?.quality.display ?? "")?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            deleteButton(chord: actionButton)
        } message: {
            Text("With base fret \(actionButton?.baseFret ?? 1000)")
        }
    }


    // MARK: Action Buttons

    /// Edit chord button
    private func editButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                sceneState.definition = chord
                chordsDatabaseState.navigationStack.append(chord)
            },
            label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
        )
    }

    /// Duplicate chord button
    private func duplicateButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                var duplicate = chord
                duplicate.id = UUID()
                sceneState.definition = duplicate
                chordsDatabaseState.navigationStack.append(duplicate)
            },
            label: {
                Label("Duplicate", systemImage: "doc.on.doc")
            }
        )
    }

    /// Confirm chord delete button
    private func confirmDeleteButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                actionButton = chord
                showDeleteConfirmation = true
            },
            label: {
                Label("Delete", systemImage: "trash")
            }
        )
    }

    /// Delete chord button
    private func deleteButton(chord: ChordDefinition?) -> some View {
        Button(
            action: {
                if let chord, let chordIndex = chordsDatabaseState.allChords.firstIndex(where: { $0.id == chord.id }) {
                    chordsDatabaseState.allChords.remove(at: chordIndex)
                }
            },
            label: {
                Text("Delete")
            }
        )
    }
}

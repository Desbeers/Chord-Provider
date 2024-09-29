//
//  ChordsDatabaseView.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 29/09/2024.
//

import SwiftUI

@MainActor struct ChordsDatabaseView: View {

    /// The app state
    @State private var appState = AppStateModel(id: .exportFolderView)
    /// The state of the scene
    @State private var sceneState = SceneStateModel(id: .exportFolderView)

    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedTab: Instrument = .guitarStandardETuning

    @State private var allChords: [ChordDefinition] = []

    @State private var chords: [ChordDefinition] = []

    @State private var search: String = ""

    var body: some View {
        VStack {
            sceneState.rootPicker
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding()
                .disabled(!search.isEmpty)

            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 110 * sceneState.settings.song.scale), spacing: 0)],
                    alignment: .center,
                    spacing: 0,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(chords) { chord in
                        diagram(chord: chord)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colorScheme == .dark ? Color.randomDark.opacity(0.2) : Color.randomLight.opacity(0.3))
                    }
                }
            }
            .overlay {
                if !search.isEmpty && chords.isEmpty {
                    ContentUnavailableView("Nothing found", systemImage: "magnifyingglass", description: Text("No chords with the name **\(search)** found."))
                }
            }
        }
        .scaleModifier
        .frame(minWidth: 800, minHeight: 600)
        .animation(.default, value: chords)
        .animation(.default, value: appState.settings)
        .searchable(text: $search)
        .task(id: sceneState.settings.song.instrument) {
            switch sceneState.settings.song.instrument {
            case .guitarStandardETuning:
                allChords = Chords.guitar
            case .guitaleleStandardATuning:
                allChords = Chords.guitalele
            case .ukuleleStandardGTuning:
                allChords = Chords.ukulele
            }
            filterChords()
        }
        .task(id: sceneState.definition) {
            filterChords()
        }
        .onChange(of: search) {
            if search.isEmpty {
                filterChords()
            } else {
                chords = allChords.filter { $0.name.localizedCaseInsensitiveContains(search) }
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
        .environment(sceneState)
    }

    func diagram(chord: ChordDefinition) -> some View {
        ChordDefinitionView(
            chord: chord,
            width: 100 * sceneState.settings.song.scale,
            settings: appState.settings
        )
        .foregroundStyle(
            .primary,
            colorScheme == .dark ? .black : .white
        )
        .animation(.default, value: appState.settings.diagram)
    }

    func filterChords() {
        chords = allChords
            .matching(root: sceneState.definition.root)
            .sorted(using: [
                KeyPathComparator(\.root), KeyPathComparator(\.bass), KeyPathComparator(\.quality)
            ])
    }
}

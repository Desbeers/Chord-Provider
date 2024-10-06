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

    /// The current color scheme
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedTab: Instrument = .guitar

    @State private var allChords: [ChordDefinition] = []

    @State private var chords: [ChordDefinition] = []

    @State private var search: String = ""

    /// Bool to show the file exporter dialog
    @State private var showExportSheet: Bool = false

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
            HStack {
                appState.mirrorToggle
                appState.notesToggle
                Spacer()
                appState.midiInstrumentPicker
            }
            Button {
                showExportSheet.toggle()
            } label: {
                Text("Export to ChordPro format")
            }
            .padding()
            .fileExporter(
                isPresented: $showExportSheet,
                document: ChordsDatabaseDocument(string: exportChords),
                contentTypes: [.json],
                defaultFilename: "ChordPro \(sceneState.settings.song.instrument) Chords"
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
        .animation(.default, value: chords)
        .animation(.smooth, value: appState.settings)
        .animation(.smooth, value: sceneState.settings)
        .searchable(text: $search)
        .task(id: sceneState.settings.song.instrument) {
            switch sceneState.settings.song.instrument {
            case .guitar:
                allChords = Chords.guitar
            case .guitalele:
                allChords = Chords.guitalele
            case .ukulele:
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
    }

    func filterChords() {
        chords = allChords
            .matching(root: sceneState.definition.root)
            .sorted(using: [
                KeyPathComparator(\.root), KeyPathComparator(\.bass), KeyPathComparator(\.quality)
            ])
    }
}

extension ChordsDatabaseView {

    private var exportChords: String {
        /// Only export basic chords
        let definitions = allChords.uniqued(by: \.name).filter { $0.root.accidental != .flat }

        var chords = definitions.map { chord in
            ChordPro.Instrument.Chord(
                name: chord.name,
                display: chord.name == chord.displayName ? nil : chord.displayName,
                base: chord.baseFret,
                frets: chord.frets,
                fingers: chord.fingers,
                copy: nil
            )
        }

        for root in Chord.Root.allCases where root.accidental == .flat {
            for copy in definitions.filter({ $0.root.copy == root }) {

                var name = root.rawValue
                name += copy.quality.rawValue
                if let bass = copy.bass {
                    name += "/\(bass.rawValue)"
                }

                chords.append(
                    .init(
                        name: name,
                        display: copy.displayName,
                        base: nil,
                        frets: nil,
                        fingers: nil,
                        copy: copy.name
                    )
                )
            }
        }

        let export = ChordPro.Instrument(
            instrument: .init(
                description: sceneState.settings.song.instrument.description,
                type: sceneState.settings.song.instrument.rawValue
            ),
            tuning: sceneState.settings.song.instrument.tuning,
            chords: chords,
            pdf: .init(diagrams: .init(vcells: 6))
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodedData = try encoder.encode(export)
            return String(decoding: encodedData, as: UTF8.self)
        } catch {
            return "error"
        }
    }
}

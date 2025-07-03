//
//  ChordsDatabaseView+grid.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension ChordsDatabaseView {

    /// View the chords in a grid
    var grid: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("Root:", selection: $chordsDatabaseState.gridRoot) {
                    ForEach(Chord.Root.naturalAndSharp.dropLast(), id: \.rawValue) { value in
                        Text(value.naturalAndSharpDisplay)
                            .tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding()
                Picker("Quality:", selection: $chordsDatabaseState.gridQuality) {
                    ForEach(Chord.Quality.allCases, id: \.rawValue) { value in
                        Text(value == .major ? "major" : value.display)
                            .tag(value)
                    }
                }
                .frame(maxWidth: 120)
                .labelsHidden()
            }
            .disabled(!chordsDatabaseState.search.isEmpty)
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 100 * sceneState.song.settings.scale.magnifier + 40), spacing: 0)],
                    alignment: .center,
                    spacing: 0,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(chordsDatabaseState.chords) { chord in
                        diagram(chord: chord)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.accentColor.opacity(Chord.Root.naturalAndSharp.contains(chord.root) ? 0.25 : 0.1))
                            .cornerRadius(6 * sceneState.song.settings.scale.magnifier)
                            .padding(4)
                    }
                    Button {
                        let root: Chord.Root = chordsDatabaseState.gridRoot == .all ? .c : chordsDatabaseState.gridRoot
                        let quality: Chord.Quality = chordsDatabaseState.gridQuality == .unknown ? .major : chordsDatabaseState.gridQuality
                        var definition: String = "base-fret 1 frets x x x x x x fingers 0 0 0 0 0 0"
                        /// Different fingering for an ukulele
                        if sceneState.song.settings.display.instrument == .ukulele {
                            definition = "base-fret 1 frets x x x x fingers 0 0 0 0"
                        }

                        if let definition = try? ChordDefinition(
                            definition: "\(root.rawValue)\(quality.rawValue) \(definition)",
                            instrument: sceneState.song.settings.display.instrument,
                            status: .addDefinition
                        ) {
                            sceneState.definition = definition
                            chordsDatabaseState.navigationStack.append(definition)
                        }
                    } label: {
                        Label("New chord", systemImage: "plus")
                    }
                    .padding()
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
        .padding(.horizontal, 4)
    }
}

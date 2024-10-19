//
//  ChordsDatabaseView+grid.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordsDatabaseView {
    var grid: some View {
        VStack(spacing: 0) {
            HStack {
                sceneState.rootPicker(showAllOption: true, hideFlats: true)
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding()
                sceneState.qualityPicker()
                    .frame(maxWidth: 120)
                    .labelsHidden()
            }
            .disabled(!chordsDatabaseState.search.isEmpty)
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 100 * sceneState.settings.song.scale + (chordsDatabaseState.editChords ? 40 : 0)), spacing: 0)],
                    alignment: .center,
                    spacing: 0,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(chordsDatabaseState.chords) { chord in
                        diagram(chord: chord)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(6)
                            .padding(4)
                    }
                    if chordsDatabaseState.editChords {
                        Button {
                            if var definition = chordsDatabaseState.chords.first {
                                definition.status = .addDefinition
                                sceneState.definition = definition
                                chordsDatabaseState.navigationStack.append(definition)
                            }
                        } label: {
                            Label("Add a new chord", systemImage: "plus")
                        }
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
        .padding(.horizontal, 4)
    }
}

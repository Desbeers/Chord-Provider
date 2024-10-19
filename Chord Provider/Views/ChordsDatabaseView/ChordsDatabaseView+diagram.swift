//
//  ChordsDatabaseView+diagram.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 19/10/2024.
//

import SwiftUI

extension ChordsDatabaseView {
    
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
            "Delete \(sceneState.definition.display)?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            deleteButton(chord: chord)
        } message: {
            Text("With base fret \(sceneState.definition.baseFret)")
        }
    }

    // MARK: Action Buttons

    /// Edit chord button
    private func editButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                sceneState.definition = chord
                sceneState.definition.status = .editDefinition
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
                sceneState.definition = chord
                sceneState.definition.status = .addDefinition
                chordsDatabaseState.navigationStack.append(chord)
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
                sceneState.definition = chord
                showDeleteConfirmation = true
            },
            label: {
                Label("Delete", systemImage: "trash")
            }
        )
    }

    /// Delete chord button
    private func deleteButton(chord: ChordDefinition) -> some View {
        Button(
            action: {
                if let chordIndex = chordsDatabaseState.allChords.firstIndex(where: { $0.id == chord.id }) {
                    chordsDatabaseState.allChords.remove(at: chordIndex)
                }
            },
            label: {
                Text("Delete")
            }
        )
    }
}

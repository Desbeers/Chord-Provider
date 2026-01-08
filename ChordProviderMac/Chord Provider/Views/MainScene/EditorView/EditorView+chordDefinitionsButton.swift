//
//  EditorView+chordDefinitionsButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button to add all chord definitions for the current instrument
    func chordDefinitionsButton() -> some View {
        Button(
            action: {
                Editor.insert(text: sceneState.song.definitions, editorInternals: sceneState.editorInternals)
            },
            label: {
                Label("Insert Chord Definitions", systemImage: "tablecells")
            }
        )
    }
}

//
//  EditorView+chordDefinitionsButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button to add all chord definitions
    func chordDefinitionsButton() -> some View {
        Button(
            action: {
                let definitions = sceneState.song.chords.map(\.define)
                let string = definitions.map { definition in
                    "{define \(definition)}"
                }
                    .joined(separator: "\n")
                Editor.insert(text: string, editorInternals: sceneState.editorInternals)
            },
            label: {
                Label("Insert Chord Definitions", systemImage: "tablecells")
            }
        )
    }
}

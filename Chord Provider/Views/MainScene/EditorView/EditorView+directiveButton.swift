//
//  EditorView+directiveButton.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button to add a directive with the selected text
    func directiveButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                sceneState.editorInternals.clickedDirective = false
                Editor.format(directive: directive, editorInternals: sceneState.editorInternals)
            },
            label: {
                Label("\(directive.details.button)…", systemImage: directive.details.icon)
            }
        )
        .disabled(sceneState.song.metadata.definedMetadata.contains(directive.rawValue.long))
    }
}

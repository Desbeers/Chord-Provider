//
//  EditorView+directiveButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// A button to add a directive with the selected text
    func directiveButton(directive: ChordPro.Directive) -> some View {
        Button(
            action: {
                Task {
                    await EditorView.format(
                        document: &document,
                        directive: directive,
                        selection: sceneState.selection,
                        definition: nil,
                        in: sceneState.textView
                    )
                }
            }, label: {
                Label("\(directive.label.text)…", systemImage: directive.label.icon)
            }
        )
    }
}

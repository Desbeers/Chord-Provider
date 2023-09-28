//
//  EditorView+EditorButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyChordUtilities

extension EditorView {

    /// A button for the text editor
    struct EditorButton: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The document
        @FocusedBinding(\.document)
        private var document: ChordProDocument?
        /// The scene
        @FocusedObject private var scene: SceneState?
        /// The label for the button
        private var label: String {
            var label = directive.label.text
            if scene?.selection.length ?? 0 > 0 {
                label += "…"
            }
            return label
        }
        /// Body of the `view`
        var body: some View {
            Button(
                action: {
                    // swiftlint:disable force_unwrapping
                    EditorView.format(
                        document: &document!,
                        directive: directive,
                        selection: scene!.selection,
                        definition: nil,
                        in: scene!.textView
                    )
                    // swiftlint:enable force_unwrapping
                }, label: {
                    Label(label, systemImage: directive.label.icon)
                }
            )
            .disabled(document == nil || scene == nil)
        }
    }
}

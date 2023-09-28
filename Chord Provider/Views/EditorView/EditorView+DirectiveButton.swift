//
//  EditorView+DirectiveButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button for the text editor to add a directive
    struct DirectiveButton: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The document
        @FocusedBinding(\.document)
        private var document: ChordProDocument?
        /// The scene
        @FocusedObject private var scene: SceneState?
        /// Body of the `view`
        var body: some View {
            Button(
                action: {
                    scene?.directive = directive
                    scene?.showDirectiveSheet = true
                }, label: {
                    Label("\(directive.label.text)…", systemImage: directive.label.icon)
                }
            )
            .disabled(document == nil || scene == nil)
        }
    }
}

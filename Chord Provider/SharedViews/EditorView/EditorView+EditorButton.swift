//
//  EditorView+EditorButton.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

extension EditorView {

    /// A button for the text editor
    struct EditorButton: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The document
        @FocusedBinding(\.document) private var document: ChordProDocument?
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
                    // swiftlint:disable:next force_unwrapping
                    EditorView.format(&document!, directive: directive, selection: scene!.selection, in: scene!.textView)
                }, label: {
                    Label(label, systemImage: directive.label.icon)
                }
            )
            .disabled(document == nil || scene == nil)
        }
    }
}

extension EditorView {

    /// The style for an editor button
    struct EditorButtonStyle: ButtonStyle {
        /// Hover state of the button
        @State private var hovered = false
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(4)
                .background(hovered ? Color.primary.opacity(0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
                .onHover { isHovered in
                    self.hovered = isHovered
                }
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
                .animation(.easeInOut(duration: 0.2), value: hovered)
        }
    }
}

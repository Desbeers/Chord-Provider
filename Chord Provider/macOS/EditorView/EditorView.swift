//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import HighlightedTextEditor

/// SwiftUI `View` for the `HighlightedTextEditor`
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The state of the scene
    @StateObject private var sceneState = SceneState()
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            toolbar
            editor
        }
        .animation(.default, value: sceneState.selection)
    }
    /// The editor
    var editor: some View {
        HighlightedTextEditor(text: $document.text, highlightRules: EditorView.rules)
        /// Below selector prevents the cursor from jumping while the SongView is updated
        /// It will also be passed to 'format' buttons
            .onSelectionChange { (range: NSRange) in
                sceneState.selection = range
            }
        /// Below is needed to interact with the NSTextView
            .introspect(callback: { editor in
                /// Setup the TextView
                if sceneState.textView == nil {
                    editor.textView.textContainerInset = NSSize(width: 10, height: 10)
                    sceneState.textView = editor.textView
                }
            })
            .focusedSceneObject(sceneState)
    }
    /// The Toolbar
    var toolbar: some View {
        HStack {
            EditorButton(directive: .startOfVerse)
            EditorButton(directive: .startOfChorus)
            EditorButton(directive: .startOfBridge)
            Spacer()
            Menu(
                content: {
                    EditorButton(directive: .comment)
                    EditorButton(directive: .define)
            }, label: {
                Label("More...", systemImage: "gear")
            })
            .menuStyle(.borderlessButton)
            .frame(width: 100)
        }
        .buttonStyle(EditorButtonStyle())
        .labelStyle(.titleAndIcon)
        .padding(10)
        .background(Color(nsColor: .windowBackgroundColor))
        .background(Color.primary.opacity(0.1))
        .cornerRadius(5)
        .padding(.top, 5)
        .padding(.horizontal, 5)
    }
}

extension EditorView {

    /// A button for the text editor
    struct EditorButton: View {
        /// The directive
        let directive: ChordPro.Directive
        /// The document
        @FocusedBinding(\.document) private var document: ChordProDocument?
        /// The scene
        @FocusedObject private var scene: SceneState?

        private var label: String {
            var label = directive.label.text
            if scene?.selection.length ?? 0 > 0 {
                label += "..."
            }
            return label
        }

        /// Body of the `view`
        var body: some View {
            Button(
                action: {
                    EditorView.format(&document!, directive: directive, selection: scene!.selection, in: scene!.textView)
                }, label: {
                    Label(label, systemImage: directive.label.icon)
                }
            )
            .disabled(document == nil && scene == nil)
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

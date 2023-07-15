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
        /// The buttons on the editor toolbar change on selection
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
            .introspect { editor in
                /// Setup the TextView
                if sceneState.textView == nil {
                    #if os(macOS)
                    editor.textView.textContainerInset = NSSize(width: 10, height: 10)
                    #endif
                    sceneState.textView = editor.textView
                }
            }
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
                },
                label: {
                    Label("More...", systemImage: "gear")
                })
            .menuStyle(.borderlessButton)
            .frame(width: 100)
        }
        .buttonStyle(EditorButtonStyle())
        .labelStyle(.titleAndIcon)
        .padding(10)
        .background(Color.primary.opacity(0.1))
        .cornerRadius(5)
        .padding(.top, 5)
        .padding(.horizontal, 5)
    }
}

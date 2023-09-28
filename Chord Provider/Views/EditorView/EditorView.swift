//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(visionOS)

/// SwiftUI `View` for the `HighlightedTextEditor`
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The scene
    @FocusedObject private var sceneState: SceneState?
    /// The body of the `View`
    var body: some View {
        TextEditor(text: $document.text)
    }
}
#else

import HighlightedTextEditor

/// SwiftUI `View` for the `HighlightedTextEditor`
struct EditorView: View {
    /// The CordPro document
    @Binding var document: ChordProDocument
    /// The scene state
    @EnvironmentObject private var sceneState: SceneState
    /// The definition of the directive sheet
    @State private var definition: String = ""
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                MarkupView()
            }
            .padding()
            editor
        }
        .sheet(
            isPresented: $sceneState.showDirectiveSheet,
            onDismiss: {
                if !definition.isEmpty {
                    EditorView.format(
                        document: &document,
                        directive: sceneState.directive,
                        selection: sceneState.selection,
                        definition: definition,
                        in: sceneState.textView
                    )
                    /// Clear the definition
                    definition = ""
                }
            },
            content: {
                DirectiveSheet(directive: sceneState.directive, definition: $definition)
            }
        )
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
    }
}

#endif

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
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppState.self) var appState
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The directive to show in the sheet
    @State var directive: ChordPro.Directive = .define
    /// The definition of the directive sheet
    @State var definition: String = ""
    /// The body of the `View`
    var body: some View {
        TextEditor(text: $document.text)
    }
}
#else

import HighlightedTextEditor

/// SwiftUI `View` for the `HighlightedTextEditor`
struct EditorView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppState.self) var appState
    /// The scene state
    @Environment(SceneState.self) var sceneState
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The directive to show in the sheet
    @State var directive: ChordPro.Directive = .define
    /// The definition of the directive sheet
    @State var definition: String = ""
    /// The body of the `View`
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                directiveMenus
            }
            .padding()
            editor
        }
        .sheet(
            isPresented: $showDirectiveSheet,
            onDismiss: {
                if !definition.isEmpty {
                    EditorView.format(
                        document: &document,
                        directive: directive,
                        selection: sceneState.selection,
                        definition: definition,
                        in: sceneState.textView
                    )
                    /// Clear the definition
                    definition = ""
                }
            },
            content: {
                DirectiveSheet(directive: directive, definition: $definition)
            }
        )
    }
    /// The editor
    var editor: some View {
        HighlightedTextEditor(
            text: $document.text,
            highlightRules: EditorView.rules(fontSize: Double(appState.settings.editorFontSize))
        )
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
                editor.textView.isIncrementalSearchingEnabled = true
#endif
                sceneState.textView = editor.textView
            }
        }
    }
}

#endif

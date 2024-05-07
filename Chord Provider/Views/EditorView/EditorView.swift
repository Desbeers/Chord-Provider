//
//  EditorView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the ``ChordProEditor``
struct EditorView: View {
    /// The ChordPro document
    @Binding var document: ChordProDocument
    /// The app state
    @Environment(AppState.self) var appState
    /// Show a directive sheet
    @State var showDirectiveSheet: Bool = false
    /// The directive to show in the sheet
    @State var directive: ChordPro.Directive = .define
    /// The definition of the directive sheet
    @State var definition: String = ""
    /// The connector class for the editor
    @State var connector = ChordProEditor.Connector(settings: ChordProviderSettings.load().editor)
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
                        directive: directive,
                        definition: definition,
                        in: connector
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
        ChordProEditor(
            text: $document.text,
            connector: connector
        )
        .task(id: appState.settings.editor) {
            connector.settings = appState.settings.editor
        }
    }
}

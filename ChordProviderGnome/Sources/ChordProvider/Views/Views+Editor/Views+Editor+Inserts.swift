//
//  Views+Editor+Inserts.swift
//  ChordProvider
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

extension Views.Editor {

    /// The `View` for inserts
    struct Inserts: View {
        /// The state of the application
        @Binding var appState: AppState
        /// Inserts
        @State private var insert = Insert()
        /// The body of the `View`
        var view: Body {
            /// - Note: Inserts for the editor
            HStack(spacing: 5) {
                Toggle("Metadata", isOn: $insert.showMetadata)
                    .style(.editorButton)
                    .popover(visible: $insert.showMetadata) {
                        Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                            .style(.addToEditorLabel)
                            .padding(.bottom)
                        Separator()
                        ForEach(ChordPro.Directive.metadataDirectives) { directive in
                            addInsert(directive: directive)
                                .insensitive(
                                    appState.editor.song.metadata.definedMetadata.contains(directive.source.long)
                                )
                        }
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
                Toggle("Environment", isOn: $insert.showEnvironment)
                    .style(.editorButton)
                    .popover(visible: $insert.showEnvironment) {
                        Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                            .style(.addToEditorLabel)
                            .padding(.bottom)
                        Separator()
                        ForEach(ChordPro.Directive.environmentDirectives) { directive in
                            addInsert(directive: directive, command: .insertDirective(directive))
                        }
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
                Toggle("More...", isOn: $insert.showMore)
                    .style(.editorButton)
                    .popover(visible: $insert.showMore) {
                        addInsert(directive: .define)
                        Button("Add all Chord definitions") {
                            appState.editor.command = .appendText(appState.editor.song.definitions)
                            insert.showMore.toggle()
                        }
                        .flat()
                        Separator()
                        addInsert(directive: .comment)
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
            }
            .insensitive(appState.scene.showSearchBar)
        }

        /// The `View` with an insert button
        @ViewBuilder func addInsert(
            directive: ChordPro.Directive,
            command: SourceViewCommand? = nil
        ) -> Body {
            let label = "\(directive.details.buttonLabel ?? directive.details.label)"
            Button(label) {
                if let command {
                    /// Apply the command
                    appState.editor.command = command
                } else if appState.editor.hasSelection {
                    appState.editor.command = .insertDirective(directive)
                } else {
                    /// Set the `directive`
                    appState.editor.handleDirective = directive
                    /// Open the dialog
                    appState.editor.showEditDirectiveDialog = true
                }
                insert = .init()
            }
            .flat()
        }

        /// Toggles for grouped inserts
        struct Insert {
            /// Insert metadata
            var showMetadata: Bool = false
            /// Insert environments
            var showEnvironment: Bool = false
            /// Insert others
            var showMore: Bool = false
        }
    }
}
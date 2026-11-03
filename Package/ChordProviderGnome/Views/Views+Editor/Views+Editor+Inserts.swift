//
//  Views+Editor+Inserts.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
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
            HStack(spacing: 5) {
                Toggle("Metadata", isOn: $insert.showMetadata)
                    .style(.editorButton)
                    .popover(visible: $insert.showMetadata) {
                        VStack {
                            Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                                .style(.addToEditorLabel)
                                .padding(.bottom)
                            Separator()
                            ForEach(ChordPro.Directive.metadataDirectives) { directive in
                                addInsert(directive: directive, command: nil)
                                    .insensitive(
                                        appState.song.metadata.definedMetadata.contains(directive.source.long)
                                    )
                            }
                        }
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
                Toggle("Environment", isOn: $insert.showEnvironment)
                    .style(.editorButton)
                    .popover(visible: $insert.showEnvironment) {
                        VStack {
                            Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                                .style(.addToEditorLabel)
                                .padding(.bottom)
                            Separator()
                            ForEach(ChordPro.Directive.environmentDirectives) { directive in
                                let directiveFormat = directive.format(wrap: appState.editor.hasSelection)
                                addInsert(
                                    directive: directive,
                                    command: .insertMarker(
                                        start: directiveFormat.start,
                                        end: directiveFormat.end,
                                        block: directiveFormat.block
                                    )
                                )
                            }
                        }
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
                Toggle("More...", isOn: $insert.showMore)
                    .style(.editorButton)
                    .popover(visible: $insert.showMore) {
                        VStack {
                            addInsert(directive: .define, command: nil)
                            Button("Add all Chord definitions") {
                                appState.editor.command = .appendText(appState.song.definitions)
                                insert.showMore.toggle()
                            }
                            .flat()
                            Separator()
                            addInsert(directive: .comment, command: nil)
                        }
                    }
                    .insensitive(!appState.editor.isAtBeginningOfLine)
            }
            .insensitive(appState.editor.showSearchBar)
        }

        /// The `View` with an insert button
        @ViewBuilder
        func addInsert(
            directive: ChordPro.Directive,
            command: SourceViewCommand?
        ) -> Body {
            let label = "\(directive.details.buttonLabel ?? directive.details.label)"
            Button(label) {
                if let command {
                    /// Apply the command
                    appState.editor.command = command
                } else if appState.editor.hasSelection {
                    let directiveFormat = directive.format(wrap: appState.editor.hasSelection)
                    appState.editor.command = .insertMarker(
                        start: directiveFormat.start,
                        end: directiveFormat.end,
                        block: directiveFormat.block
                    )
                } else {
                    /// Set the `directive`
                    appState.scene.handleDirective = directive
                    /// Open the dialog
                    appState.scene.showEditDirectiveDialog = true
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

//
//  Views+Editor+Inserts.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceEditor

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
                            Text("\(appState.bridge.hasSelection ? "Wrap" : "Insert")")
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
                    .insensitive(!appState.bridge.isAtBeginningOfLine)
                Toggle("Environment", isOn: $insert.showEnvironment)
                    .style(.editorButton)
                    .popover(visible: $insert.showEnvironment) {
                        VStack {
                            Text("\(appState.bridge.hasSelection ? "Wrap" : "Insert")")
                                .style(.addToEditorLabel)
                                .padding(.bottom)
                            Separator()
                            ForEach(ChordPro.Directive.environmentDirectives) { directive in
                                let directiveFormat = directive.format(wrap: appState.bridge.hasSelection)
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
                    .insensitive(!appState.bridge.isAtBeginningOfLine)
                Toggle("More...", isOn: $insert.showMore)
                    .style(.editorButton)
                    .popover(visible: $insert.showMore) {
                        VStack {
                            addInsert(directive: .define, command: nil)
                            Button("Add all Chord definitions") {
                                appState.controller.command(.appendText(appState.song.definitions))
                                insert.showMore.toggle()
                            }
                            .flat()
                            Separator()
                            addInsert(directive: .comment, command: nil)
                        }
                    }
                    .insensitive(!appState.bridge.isAtBeginningOfLine)
            }
            .insensitive(appState.bridge.showSearchBar)
        }

        /// The `View` with an insert button
        @ViewBuilder
        func addInsert(
            directive: ChordPro.Directive,
            command: Editor.Command?
        ) -> Body {
            let label = "\(directive.details.buttonLabel ?? directive.details.label)"
            Button(label) {
                if let command {
                    /// Apply the command
                    appState.controller.command(command)
                } else if appState.bridge.hasSelection {
                    let directiveFormat = directive.format(wrap: appState.bridge.hasSelection)
                    appState.controller.command(
                        .insertMarker(
                            start: directiveFormat.start,
                            end: directiveFormat.end,
                            block: directiveFormat.block
                        )
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

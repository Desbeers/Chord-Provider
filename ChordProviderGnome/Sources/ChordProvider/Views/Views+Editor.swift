//
//  Views+Editor.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import ChordProviderCore
import SourceView

extension Views {

    /// The `View` for editing a song
    struct Editor: View {
        init(appState: Binding<AppState>) {
            self._appState = appState
        }
        /// The state of the application
        @Binding var appState: AppState
        /// Confirmation for cleanup
        @State private var confirmCleanup: Bool = false
        /// Inserts
        @State private var inserts = Inserts()
        /// The body of the `View`
        var view: Body {
            VStack {
                /// - Note: Inserts for the editor
                HStack(spacing: 5) {
                    Toggle("Metadata", isOn: $inserts.showMetadata)
                        .style(.editorButton)
                        .popover(visible: $inserts.showMetadata) {
                            Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                                .style(.addToEditorLabel)
                                .padding(.bottom)
                            Separator()
                            ForEach(ChordPro.Directive.metadataDirectives) { directive in
                                addInsert(directive: directive)
                                    .insensitive(appState.editor.song.metadata.definedMetadata.contains(directive.rawValue.long))
                            }
                        }
                    Toggle("Environment", isOn: $inserts.showEnvironment)
                        .style(.editorButton)
                        .popover(visible: $inserts.showEnvironment) {
                            Text("\(appState.editor.hasSelection ? "Wrap" : "Insert")")
                                .style(.addToEditorLabel)
                                .padding(.bottom)
                            Separator()
                            ForEach(ChordPro.Directive.environmentDirectives) { directive in
                                addInsert(directive: directive, command: .insertDirective(directive: directive))
                            }
                        }
                    Toggle("More...", isOn: $inserts.showMore)
                        .style(.editorButton)
                        .popover(visible: $inserts.showMore) {
                            addInsert(directive: .define)
                            Button("Add all Chord definitions") {
                                appState.editor.command = .appendText(text: appState.editor.song.definitions)
                                inserts.showMore.toggle()
                            }
                            .flat()
                            /// - Note: This is fine
                            Separator()
                            addInsert(directive: .comment)
                        }
                }
                .padding(5)
                .halign(.center)
                /// - Note: Disable all *inserts* when we are not a the beginning of a new line
                .insensitive(!appState.editor.isAtBeginningOfLine)
                Separator()
                ScrollView {
                    SourceView(bridge: $appState.editor, controller: appState.controller, language: .chordpro)
                        .innerPadding(10, edges: .all)
                        .lineNumbers(appState.settings.editor.showLineNumbers)
                        .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                        .highlightCurrentLine(true)
                        .vexpand()
                }
                Separator()
                lineInfo
            }
            .card()
            .padding()
            .dialog(visible: $appState.editor.showEditDirectiveDialog) {
                switch appState.editor.handleDirective {
                case .define, .defineGuitar, .defineGuitalele, .defineUkulele:
                    Views.DefineChord(appState: $appState)
                default:
                    Edit(appState: $appState)
                }
            }
        }
        @ViewBuilder
        var lineInfo: Body {
            HStack {
                Text("Line \(appState.editor.currentLine.sourceLineNumber)")
                    .frame(maxWidth: 120)
                    .halign(.start)
                    .padding()
                ScrollView {
                    if let warnings = appState.editor.currentLine.warnings {
                        Text(warnings.map(\.message).joined(separator: "\n"))
                            .useMarkup()
                            .halign(.start)
                            .hexpand()
                    } else {
                        Text(" ")
                            .hexpand()
                    }
                }
                Button("Cleanup") {
                    confirmCleanup.toggle()
                }
                .padding()
                .insensitive(!appState.editor.song.hasWarnings)
                .halign(.end)
                .valign(.center)
                .alertDialog(
                    visible: $confirmCleanup,
                    heading: "Cleanup",
                    body: "Are you sure you want to cleanup the song?",
                    id: "cleanup-dialog",
                    extraChild: {
                        Text("You can always undo this.")
                    }
                )
                .response("Cancel", role: .none) {
                    /// Nothing to do
                }
                .response("Cleanup", appearance: .suggested, role: .default) {
                    appState.editor.command = .replaceAllText(text: appState.editor.song.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n"))
                }
            }
            .style(.caption)
        }

        @ViewBuilder
        func addInsert(
            directive: ChordPro.Directive,
            command: SourceViewCommand? = nil
        ) -> Body {
            let label = "\(directive.details.buttonLabel ?? directive.details.label)"
            Button(label) {
                if let command {
                    /// Apply the command
                    appState.editor.command = command
                } else {
                    /// Set the `directive`
                    appState.editor.handleDirective = directive
                    /// Open the dialog
                    appState.editor.showEditDirectiveDialog = true
                }
                inserts = .init()
            }
            .flat()
        }

        struct Inserts {
            var showMetadata: Bool = false
            var showEnvironment: Bool = false
            var showMore: Bool = false
        }
    }
}

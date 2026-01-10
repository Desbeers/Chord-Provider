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
            self.lines = appState.wrappedValue.editor.song.sections.flatMap(\.lines).filter {$0.sourceLineNumber > 0}
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The current song lines
        let lines: [Song.Section.Line]
        /// Confirmation for cleanup
        @State private var confirmCleanup: Bool = false
        /// Inserts
        @State private var inserts = Inserts()
        /// The body of the `View`
        var view: Body {
            VStack {
                /// - Note: Inserts for the editor
                HStack {
                    Text("Metadata")
                        .style(.editorButton)
                        .padding(5)
                        .onClick {
                            inserts.showMetadata.toggle()
                        }
                        .popover(visible: $inserts.showMetadata) {
                            ForEach(ChordPro.Directive.metadataDirectives) { directive in
                                addInsert(directive: directive)
                                    .insensitive(appState.editor.song.metadata.definedMetadata.contains(directive.rawValue.long))
                            }
                        }
                    Text("Environment")
                        .style(.editorButton)
                        .padding(5)
                        .onClick {
                            inserts.showEnvironment.toggle()
                        }
                        .popover(visible: $inserts.showEnvironment) {
                            ForEach(ChordPro.Directive.environmentDirectives) { directive in
                                addInsert(directive: directive)
                            }
                        }
                    Text("more...")
                        .style(.editorButton)
                        .padding(5)
                        .onClick {
                            inserts.showMore.toggle()
                        }
                        .popover(visible: $inserts.showMore) {
                            // - TODO: Make this more fancy
                            Button("Define a new Chord") {
                                appState.scene.showDefineChordDialog.toggle()
                                inserts.showMore.toggle()
                            }
                            .flat()
                            /// - Note: This is fine
                            addInsert(directive: .define, command: .appendText(text: appState.editor.song.definitions))
                            Separator()
                            addInsert(directive: .comment)
                        }
                }
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
            .dialog(visible: $appState.scene.showDefineChordDialog) {
                Views.DefineChord(appState: $appState)
            }
        }
        @ViewBuilder
        var lineInfo: Body {
            HStack {
                let currentLine = getCurrentLine(lineNumber: appState.editor.currentLine)
                Text("Line \(currentLine.sourceLineNumber)")
                    .frame(maxWidth: 120)
                    .halign(.start)
                    .padding()
                ScrollView {
                    if let warnings = currentLine.warnings {
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

        func getCurrentLine(lineNumber: Int) -> Song.Section.Line {
            lines[safe: lineNumber - 1] ?? Song.Section.Line()
        }

        @ViewBuilder
        func addInsert(
            directive: ChordPro.Directive = .title,
            command: SourceViewCommand? = nil
        ) -> Body {
            Button(directive.details.buttonLabel ?? directive.details.label) {
                appState.editor.command = command ?? .insertDirective(directive: directive)
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

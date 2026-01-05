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
        
        @State private var showMetadata: Bool = false
        @State private var showEnvironment: Bool = false
        @State private var showMore: Bool = false
        /// The body of the `View`
        var view: Body {
            VStack {
                VStack {
                    HStack {
                        Text("Metadata")
                            .style(.editorButton)
                            .padding(5)
                            .onClick {
                                showMetadata.toggle()
                            }
                            .popover(visible: $showMetadata) {
                                ForEach(ChordPro.Directive.metadataDirectives) { directive in
                                    Button(directive.details.label) {
                                        appState.editor.command = .insertDirective(directive: directive)
                                        showMetadata.toggle()
                                    }
                                    .flat()
                                    .insensitive(appState.editor.song.metadata.definedMetadata.contains(directive.rawValue.long))
                                }
                            }
                        Text("Environment")
                            .style(.editorButton)
                            .padding(5)
                            .onClick {
                                showEnvironment.toggle()
                            }
                            .popover(visible: $showEnvironment) {
                                ForEach(ChordPro.Directive.environmentDirectives) { directive in
                                    Button(directive.details.buttonLabel ?? directive.details.label) {
                                        appState.editor.command = .insertDirective(directive: directive)
                                        showEnvironment.toggle()
                                    }
                                    .flat()
                                    .insensitive(appState.editor.song.metadata.definedMetadata.contains(directive.rawValue.long))
                                }
                            }
                        Text("more...")
                            .style(.editorButton)
                            .padding(5)
                            .onClick {
                                showMore.toggle()
                            }
                            .popover(visible: $showMore) {
                                Button("Comment") {
                                    appState.editor.command = .insertDirective(directive: .comment)
                                    showMore.toggle()
                                }
                                .flat()
                            }
                    }
                    .halign(.center)
                    Separator()
                    ScrollView {
                        SourceView(bridge: $appState.editor)
                            .innerPadding(10, edges: .all)
                            .lineNumbers(appState.settings.editor.showLineNumbers)
                            .language(.chordpro)
                            .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                            .highlightCurrentLine(true)
                            .vexpand()
                            .css {
                                "textview { font-family: Monospace; font-size: \(appState.settings.editor.fontSize.rawValue)pt; }"
                            }
                    }
                    Separator()
                    lineInfo
                }
                .card()
                .padding()
            }
        }
        @ViewBuilder
        var lineInfo: Body {
            HStack {
                let currentLine = getCurrentLine(lineNumber: appState.editor.currentLine)
                Text("Line \(currentLine.sourceLineNumber)")
                    .frame(maxWidth: 120)
                    .halign(.start)
                    .padding(.trailing)
                if let warnings = currentLine.warnings {
                    VStack {
                        ForEach(warnings) { warning in
                            Text(warning.message)
                                .useMarkup()
                                .halign(.start)
                        }
                    }
                    .hexpand()
                    .valign(.center)
                } else {
                    Text(" ")
                        .hexpand()
                }
                Button("Cleanup") {
                    confirmCleanup.toggle()
                }
                .insensitive(!appState.editor.song.hasWarnings)
                .halign(.end)
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
            .hexpand()
            //.halign(.start)
            .padding()
        }
        func getCurrentLine(lineNumber: Int) -> Song.Section.Line {
            lines[safe: lineNumber - 1] ?? Song.Section.Line()
        }
    }
}

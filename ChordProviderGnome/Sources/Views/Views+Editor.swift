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
        init(appState: Binding<AppState>, song: Song) {
            self._appState = appState
            self.song = song
            self.lines = song.sections.flatMap(\.lines).filter {$0.sourceLineNumber > 0}
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The whole song
        let song: Song
        /// The current song lines
        let lines: [Song.Section.Line]
        /// Confirmation for cleanup
        @State private var confirmCleanup: Bool = false
        /// The body of the `View`
        var view: Body {
            VStack {
                VStack {
                    HStack {
                        Button("Verse") {
                            appState.bridge.command = .insert(
                                text: "\n{start_of_verse}\n{end_of_verse}\n",
                                wrapSelectionWith: (prefix: "{start_of_verse}\n", suffix: "\n{end_of_verse}\n")
                            )
                        }
                        .flat()
                        Button("Chorus") {
                            appState.bridge.command = .insert(
                                text: "\n{start_of_chorus}\n{end_of_chorus}\n",
                                wrapSelectionWith: (prefix: "{start_of_chorus}\n", suffix: "\n{end_of_chorus}\n")
                            )
                        }
                        .flat()
                        Button("Comment") {
                            appState.bridge.command = .insert(
                                text: "\n{comment ...}\n",
                                wrapSelectionWith: (prefix: "{comment ", suffix: "}\n")
                            )
                        }
                        .flat()
                    }
                    .halign(.center)
                    Separator()
                    ScrollView {
                        SourceView(text: $appState.scene.source, bridge: $appState.bridge)
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
                let currentLine = getCurrentLine(lineNumber: appState.bridge.currentLine)
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
                    appState.bridge.command = .replaceAllText(text: song.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n"))
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

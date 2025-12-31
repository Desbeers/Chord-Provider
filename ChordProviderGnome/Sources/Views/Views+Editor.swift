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
            self.lines = song.sections.flatMap(\.lines)
        }
        /// The state of the application
        @Binding var appState: AppState
        /// The current song lines
        let lines: [Song.Section.Line]
        /// The editor bridge
        @State private var bridge = SourceViewBridge()
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 0) {
                Separator()
                HStack {
                    Button("Verse") {
                        bridge.command = .insert(
                            text: "\n{start_of_verse}\n{end_of_verse}\n",
                            wrapSelectionWith: (prefix: "{start_of_verse}\n", suffix: "\n{end_of_verse}\n")
                        )
                    }
                    .flat()
                    Button("Chorus") {
                        bridge.command = .insert(
                            text: "\n{start_of_chorus}\n{end_of_chorus}\n",
                            wrapSelectionWith: (prefix: "{start_of_chorus}\n", suffix: "\n{end_of_chorus}\n")
                        )
                    }
                    .flat()
                    Button("Comment") {
                        bridge.command = .insert(
                            text: "\n{comment ...}\n",
                            wrapSelectionWith: (prefix: "{comment ", suffix: "}\n")
                        )
                    }
                    .flat()
                }
                .halign(.center)
                ScrollView {
                    SourceView(text: $appState.scene.source, bridge: $bridge)
                        .innerPadding(10, edges: [.top, .trailing, .bottom])
                        .lineNumbers(appState.settings.editor.showLineNumbers)
                        .language(.chordpro)
                        .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                        .highlightCurrentLine(true)
                        .vexpand()
                        .css {
                            "textview { font-family: Monospace; font-size: \(appState.settings.editor.fontSize.rawValue)pt; }"
                        }
                        .card()
                        .padding([.leading, .trailing, .bottom])
                }
                lineInfo
            }
        }
        @ViewBuilder
        var lineInfo: Body {
            HStack {
                let currentLine = getCurrentLine(lineNumber: bridge.currentLine)
                Text("Line \(currentLine.sourceLineNumber)")
                    .frame(minWidth: 50)
                    .halign(.start)
                if let warnings = currentLine.warnings {
                    ForEach(warnings) { warning in
                        Text(warning.message)
                            .useMarkup()
                            .halign(.start)
                    }
                }
            }
            .style(.caption)
            .halign(.start)
            .padding([.leading, .bottom])
        }
        func getCurrentLine(lineNumber: Int) -> Song.Section.Line {
            var result = Song.Section.Line()
            if let line = lines.first(where: { $0.sourceLineNumber == lineNumber }) {
                result = line
            }
            return result
        }
    }
}

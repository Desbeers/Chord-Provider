//
//  Views+Editor.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView

extension Views {

    /// The `View` for editing a song
    struct Editor: View {
        /// The state of the application
        @Binding var appState: AppState

        @State private var editorCommand: SourceViewCommand?
        /// The body of the `View`
        var view: Body {
            VStack(spacing: 0) {
                Separator()
                HStack {
                    Button("Verse") {
                        editorCommand = .insert(
                            text: "\n{start_of_verse}\n{end_of_verse}\n",
                            wrapSelectionWith: (prefix: "{start_of_verse}\n", suffix: "\n{end_of_verse}\n")
                        )
                    }
                    .flat()
                    Button("Chorus") {
                        editorCommand = .insert(
                            text: "\n{start_of_chorus}\n{end_of_chorus}\n",
                            wrapSelectionWith: (prefix: "{start_of_chorus}\n", suffix: "\n{end_of_chorus}\n")
                        )
                    }
                    .flat()
                    Button("Comment") {
                        editorCommand = .insert(
                            text: "\n{comment ...}\n",
                            wrapSelectionWith: (prefix: "{comment ", suffix: "}\n")
                        )
                    }
                    .flat()
                }
                .halign(.center)
                ScrollView {
                    SourceView(text: $appState.scene.source, command: $editorCommand)
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
            }
        }
    }
}

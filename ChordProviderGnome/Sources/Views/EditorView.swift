//
//  EditorView.swift
//  ChordProviderGnome
//
//  © 2025 Nick Berendsen
//

import Foundation
import Adwaita
import SourceView
import ChordProviderCore
import ChordProviderHTML

/// The `View` for editing a song
struct EditorView: View {
    /// The ``AppState``
    @Binding var appState: AppState
    /// The body of the `View`
    var view: Body {
        VStack(spacing: 0) {
            ScrollView {
                SourceView(text: $appState.scene.source)
                    .innerPadding()
                    .lineNumbers(appState.settings.editor.showLineNumbers)
                    .language(.chordpro)
                    .wrapMode(appState.settings.editor.wrapLines ? .word : .none)
                    .highlightCurrentLine(true)
                    .vexpand()
                    .css {
                        "textview { font-family: Monospace; font-size: \(appState.settings.editor.fontSize.rawValue)pt; }"
                    }
                    .card()
                    .padding(8)
            }
            HStack {
                Button("Clean Source") {
                    let song = Song(id: UUID(), content: appState.scene.source)
                    let result = ChordProParser.parse(
                        song: song,
                        settings: appState.settings.core
                    )
                    appState.scene.source = result.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                }
                .padding(4)
            }
            .halign(.center)
        }
    }
}

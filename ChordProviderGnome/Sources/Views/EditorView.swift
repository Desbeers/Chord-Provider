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
    /// The ``AppSettings``
    @Binding var settings: AppSettings
    /// The body of the `View`
    var view: Body {
        VStack(spacing: 0) {
            ScrollView {
                SourceView(text: $settings.app.source)
                    .innerPadding()
                    .lineNumbers(settings.editor.showLineNumbers)
                    .language(.chordpro)
                    .wrapMode(settings.editor.wrapLines ? .word : .none)
                    .highlightCurrentLine(true)
                    .vexpand()
                    .css {
                        "textview { font-family: Monospace; font-size: \(settings.editor.fontSize.rawValue)pt; }"
                    }
                    .card()
                    .padding(8)
            }
            HStack {
                Button("Clean Source") {
                    let song = Song(id: UUID(), content: settings.app.source)
                    let result = ChordProParser.parse(
                        song: song,
                        settings: settings.core
                    )
                    settings.app.source = result.sections.flatMap(\.lines).map(\.sourceParsed).joined(separator: "\n")
                }
                .padding(4)
            }
            .halign(.center)
        }
    }
}
